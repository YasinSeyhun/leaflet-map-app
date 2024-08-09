require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const db = require('./db');
const path = require('path');

const app = express();
app.use(bodyParser.json());

app.use(express.static(path.join(__dirname, 'public')));

// Get all markers
app.get('/api/getMarkers', async (req, res) => {
  try {
    const result = await db.query('SELECT id, lat, lng, marker_adi FROM leaflet_map');
    res.json({
      success: true,
      message: 'Markers fetched successfully',
      data: result.rows
    });
  } catch (error) {
    console.error('Error fetching markers:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching markers'
    });
  }
});

// Add a new marker
app.post('/api/addMarker', async (req, res) => {
  const { lat, lng, marker_adi } = req.body;
  try {
    const result = await db.query(
      'INSERT INTO leaflet_map (lat, lng, marker_adi) VALUES ($1, $2, $3) RETURNING id',
      [lat, lng, marker_adi]
    );
    res.json({
      success: true,
      message: 'Marker added successfully',
      data: { id: result.rows[0].id }
    });
  } catch (error) {
    console.error('Error adding marker:', error);
    res.status(500).json({
      success: false,
      message: 'Error adding marker'
    });
  }
});

// Update marker name
app.put('/api/updateMarker', async (req, res) => {
  const { lat, lng, marker_adi } = req.body;
  try {
    await db.query('UPDATE leaflet_map SET marker_adi = $1 WHERE lat = $2 AND lng = $3', [marker_adi, lat, lng]);
    console.log(`Marker (${lat}, ${lng}) updated with name: ${marker_adi}`);
    res.json({
      success: true,
      message: 'Marker updated successfully'
    });
  } catch (error) {
    console.error('Error updating marker:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating marker'
    });
  }
});

// Delete a marker
app.delete('/api/deleteMarker', async (req, res) => {
  const { lat, lng } = req.body;
  try {
    await db.query('DELETE FROM leaflet_map WHERE lat = $1 AND lng = $2', [lat, lng]);
    console.log(`Marker (${lat}, ${lng}) deleted`);
    res.json({
      success: true,
      message: 'Marker deleted successfully'
    });
  } catch (error) {
    console.error('Error deleting marker:', error);
    res.status(500).json({
      success: false,
      message: 'Error deleting marker'
    });
  }
});

// Delete all markers
app.delete('/api/clearMarkers', async (req, res) => {
  try {
    await db.query('DELETE FROM leaflet_map');
    console.log('All markers deleted');
    res.json({
      success: true,
      message: 'All markers deleted successfully'
    });
  } catch (error) {
    console.error('Error clearing markers:', error);
    res.status(500).json({
      success: false,
      message: 'Error clearing markers'
    });
  }
});

const port = 3000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
