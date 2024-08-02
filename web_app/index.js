require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const db = require('./db');
const path = require('path');

const app = express();
app.use(bodyParser.json());

app.use(express.static(path.join(__dirname, 'public')));

// Tüm markerları getir
app.get('/api/getMarkers', async (req, res) => {
  try {
    const result = await db.query('SELECT id, lat, lng, marker_adi FROM leaflet_map');
    res.json(result.rows);
  } catch (error) {
    console.error('Markerlar fetching yapılırken hata oluştu:', error);
    res.status(500).send('Server error');
  }
});

// Yeni marker ekle
app.post('/api/addMarker', async (req, res) => {
  const { lat, lng, marker_adi } = req.body;
  try {
    const result = await db.query(
      'INSERT INTO leaflet_map (lat, lng, marker_adi) VALUES ($1, $2, $3) RETURNING id',
      [lat, lng, marker_adi]
    );
    res.json({ id: result.rows[0].id });
  } catch (error) {
    console.error("Marker database'e eklenirken hata oluştu :", error);
    res.status(500).send('Server error');
  }
});

// Marker ismini güncelle
app.put('/api/updateMarker', async (req, res) => {
  const { lat, lng, marker_adi } = req.body;
  try {
    await db.query('UPDATE leaflet_map SET marker_adi = $1 WHERE lat = $2 AND lng = $3', [marker_adi, lat, lng]);
    console.log(`Marker (${lat}, ${lng}) updated with name: ${marker_adi}`);
    res.send("Marker ismi database'de güncellendi");
  } catch (error) {
    console.error('Marker ismi güncellenirken hata oluştu:', error);
    res.status(500).send('Server error');
  }
});

// Marker sil
app.delete('/api/deleteMarker', async (req, res) => {
  const { lat, lng } = req.body;
  try {
    await db.query('DELETE FROM leaflet_map WHERE lat = $1 AND lng = $2', [lat, lng]);
    console.log(`Marker (${lat}, ${lng}) deleted`);
    res.send('Marker databaseden silindi');
  } catch (error) {
    console.error('Marker databaseden silinirken hata oluştu:', error);
    res.status(500).send('Server error');
  }
});

// Tüm markerları sil
app.delete('/api/clearMarkers', async (req, res) => {
  try {
    await db.query('DELETE FROM leaflet_map');
    console.log('All markers deleted');
    res.send('All markers deleted');
  } catch (error) {
    console.error('Error clearing markers:', error);
    res.status(500).send('Server error');
  }
});

const port = 3000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
