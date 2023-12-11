const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs').promises;

const app = express();
const port = 3000;
const uploadDir = path.join(__dirname, 'uploads');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  },
});

const upload = multer({ storage });

app.use(express.static('public'));

// Route to fetch file names
app.get('/files', async (req, res) => {
  try {
    const files = await fs.readdir(uploadDir);
    res.json(files);
  } catch (error) {
    console.error('Error fetching file names:', error);
    res.status(500).send('Internal Server Error');
  }
});

// Route to handle file uploads
app.post('/upload', upload.single('file'), (req, res) => {
  if (!req.file) {
    console.error('No file uploaded.');
    return res.status(400).send('No file uploaded.');
  }

  const filePath = path.join(uploadDir, req.file.filename);
  console.log(`File uploaded: ${filePath}`);

  res.status(200).send('File uploaded successfully.');
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
