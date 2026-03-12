# 🔧 Backend para Inventario de PC

Este es el backend API que se conecta con MongoDB para guardar el inventario de PCs.

## 📋 Requisitos previos

- Node.js v14 o superior
- MongoDB (local o Atlas)
- npm o yarn

## 🚀 Instalación

### 1. Crear carpeta del backend

```bash
mkdir inventario_backend
cd inventario_backend
```

### 2. Inicializar proyecto Node.js

```bash
npm init -y
```

### 3. Instalar dependencias

```bash
npm install express mongoose cors dotenv
npm install --save-dev nodemon
```

## 📝 Estructura de archivos

```
inventario_backend/
├── .env
├── server.js
├── models/
│   └── Pc.js
├── routes/
│   └── pcRoutes.js
└── controllers/
    └── pcController.js
```

## 🔑 Archivos a crear

### 1. `.env` - Variables de entorno

```env
PORT=3000
MONGODB_URI=mongodb://localhost:27017/inventario_db
NODE_ENV=development
```

Si usas MongoDB Atlas:
```env
PORT=3000
MONGODB_URI=mongodb+srv://usuario:contraseña@cluster.mongodb.net/inventario_db
NODE_ENV=development
```

### 2. `server.js` - Archivo principal

```javascript
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Conexión a MongoDB
mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log('✅ Conectado a MongoDB'))
  .catch(err => console.log('❌ Error de conexión:', err));

// Rutas
const pcRoutes = require('./routes/pcRoutes');
app.use('/api', pcRoutes);

// Iniciar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en puerto ${PORT}`);
});
```

### 3. `models/Pc.js` - Esquema de MongoDB

```javascript
const mongoose = require('mongoose');

const pcSchema = new mongoose.Schema({
  ubicacion: {
    type: String,
    required: true
  },
  responsable: {
    type: String,
    required: true
  },
  puesto: {
    type: String,
    required: true
  },
  seccion: {
    type: String,
    required: true
  },
  marca: {
    type: String,
    required: true
  },
  numeroSerie: {
    type: String,
    required: true,
    unique: true
  },
  discoDuro: String,
  memoriaRam: String,
  windows: String,
  tarjetaGrafica: String,
  contrasena: String,
  correoInstitucional: String,
  clave: String,
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Pc', pcSchema);
```

### 4. `controllers/pcController.js` - Lógica de negocio

```javascript
const Pc = require('../models/Pc');

// Crear nuevo PC
exports.createPc = async (req, res) => {
  try {
    const newPc = new Pc(req.body);
    const savedPc = await newPc.save();
    res.status(201).json(savedPc);
  } catch (error) {
    if (error.code === 11000) {
      res.status(400).json({ 
        error: 'El número de serie ya existe' 
      });
    } else {
      res.status(500).json({ error: error.message });
    }
  }
};

// Obtener todos los PCs
exports.getAllPcs = async (req, res) => {
  try {
    const pcs = await Pc.find();
    res.json(pcs);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Obtener un PC por ID
exports.getPcById = async (req, res) => {
  try {
    const pc = await Pc.findById(req.params.id);
    if (!pc) {
      return res.status(404).json({ error: 'PC no encontrado' });
    }
    res.json(pc);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Actualizar PC
exports.updatePc = async (req, res) => {
  try {
    const pc = await Pc.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );
    if (!pc) {
      return res.status(404).json({ error: 'PC no encontrado' });
    }
    res.json(pc);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Eliminar PC
exports.deletePc = async (req, res) => {
  try {
    const pc = await Pc.findByIdAndDelete(req.params.id);
    if (!pc) {
      return res.status(404).json({ error: 'PC no encontrado' });
    }
    res.json({ message: 'PC eliminado exitosamente' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
```

### 5. `routes/pcRoutes.js` - Rutas API

```javascript
const express = require('express');
const router = express.Router();
const pcController = require('../controllers/pcController');

router.post('/pcs', pcController.createPc);
router.get('/pcs', pcController.getAllPcs);
router.get('/pcs/:id', pcController.getPcById);
router.put('/pcs/:id', pcController.updatePc);
router.delete('/pcs/:id', pcController.deletePc);

module.exports = router;
```

## ▶️ Ejecutar el servidor

Añade a `package.json`:

```json
"scripts": {
  "start": "node server.js",
  "dev": "nodemon server.js"
}
```

Luego ejecuta:

```bash
npm run dev
```

El servidor estará disponible en `http://localhost:3000`

## 🧪 Probar la API

### Crear PC (POST)
```bash
curl -X POST http://localhost:3000/api/pcs \
  -H "Content-Type: application/json" \
  -d '{
    "ubicacion": "Oficina 101",
    "responsable": "Juan Pérez",
    "puesto": "Desarrollador",
    "seccion": "TI",
    "marca": "Dell",
    "numeroSerie": "SN123456"
  }'
```

### Obtener todos (GET)
```bash
curl http://localhost:3000/api/pcs
```

## 📱 Conectar desde Flutter

En `lib/services/pc_service.dart`, cambia:

```dart
static const String baseUrl = 'http://10.0.2.2:3000/api'; // Para Android
// o
static const String baseUrl = 'http://localhost:3000/api'; // Para Web/Desktop
```

Para **Android emulator**, usa `10.0.2.2` en lugar de `localhost`.

## 🔐 Notas de seguridad

- En producción, usa variables de entorno para sensibles
- Implementa autenticación (JWT)
- Valida inputs en el backend
- Usa HTTPS en lugar de HTTP
