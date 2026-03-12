# 📚 Guía Completa: Guardar Inventario de PC en MongoDB

## ✅ Cambios realizados en tu app Flutter:

### 1. **Nuevo servicio API** - `lib/services/pc_service.dart`
- Maneja todas las llamadas HTTP a MongoDB
- Métodos: `savePc()`, `getAllPcs()`, `updatePc()`, `deletePc()`

### 2. **Actualizado** - `lib/Screens/add_pc_screen.dart`
- Ahora guarda en MongoDB al presionar "Agregar PC"
- Muestra mensajes de éxito/error
- Valida campos requeridos

### 3. **Actualizado** - `lib/Screens/inventory_screen.dart`
- Carga PCs desde MongoDB al abrir la app
- Permite refrescar datos (pull to refresh)
- Respaldo: si no hay conexión, carga datos locales de SharedPreferences

### 4. **Actualizado** - `pubspec.yaml`
- Agregado: `http: ^1.1.0` para llamadas HTTP

---

## 🚀 Pasos para implementar el Backend

### **Opción A: Backend Local (Recomendado para desarrollo)**

**1. Instalar MongoDB localmente**
- Descarga desde: https://www.mongodb.com/try/download/community
- Instala siguiendo el instalador

**2. Crear carpeta del backend**
```bash
cd d:\Estadias2026\proyect
mkdir inventario_backend
cd inventario_backend
npm init -y
```

**3. Instalar dependencias**
```bash
npm install express mongoose cors dotenv
npm install --save-dev nodemon
```

**4. Copiar los archivos desde `BACKEND_SETUP.md`**
Crea estas carpetas y archivos:
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

**5. Configurar MongoDB**
En `.env`:
```env
PORT=3000
MONGODB_URI=mongodb://localhost:27017/inventario_db
NODE_ENV=development
```

**6. Ejecutar el servidor**
```bash
npm run dev
```

Deberías ver:
```
✅ Conectado a MongoDB
🚀 Servidor corriendo en puerto 3000
```

---

### **Opción B: Backend en la Nube (MongoDB Atlas)**

**1. Crear cuenta en MongoDB Atlas**
- Ve a: https://www.mongodb.com/cloud/atlas
- Crea cuenta gratis
- Crea un cluster

**2. Obtener connection string**
- En Atlas, copia el "Connection String"
- Reemplaza `<password>` con tu contraseña

**3. En `.env` del backend:**
```env
PORT=3000
MONGODB_URI=mongodb+srv://usuario:contraseña@cluster.mongodb.net/inventario_db
NODE_ENV=development
```

---

## 📱 Configurar URL en Flutter

Abre `lib/services/pc_service.dart` y actualiza:

**Para desarrollo local:**
```dart
static const String baseUrl = 'http://localhost:3000/api';  // Web/Desktop
// o
static const String baseUrl = 'http://10.0.2.2:3000/api';   // Android Emulator
```

**Para producción:**
```dart
static const String baseUrl = 'https://tudominio.com/api';
```

---

## 🧪 Probar la API

### Desde Postman o cURL:

**Crear PC:**
```bash
POST http://localhost:3000/api/pcs
Content-Type: application/json

{
  "ubicacion": "Oficina 101",
  "responsable": "Juan Pérez",
  "puesto": "Desarrollador",
  "seccion": "TI",
  "marca": "Dell",
  "numeroSerie": "SN123456",
  "discoDuro": "512GB SSD",
  "memoriaRam": "16GB",
  "windows": "Windows 10",
  "tarjetaGrafica": "NVIDIA GTX 1650",
  "contrasena": "pass123",
  "correoInstitucional": "juan@empresa.com",
  "clave": "ABC123"
}
```

**Obtener todos:**
```bash
GET http://localhost:3000/api/pcs
```

---

## 🔄 Flujo de datos

```
Flutter App
    ↓ (Presiona "Agregar PC")
    ↓ (Datos del formulario)
    ↓
PcService.savePc()
    ↓ (HTTP POST)
    ↓
Backend (Node.js)
    ↓ (Procesa datos)
    ↓
MongoDB
    ↓ (Guarda documento)
    ↓
Respuesta 201 Created
    ↓ (HTTP)
    ↓
Flutter: "PC guardado exitosamente"
```

---

## 💾 Respaldo Local

Si el servidor está offline:
- Los datos se guardan también en `SharedPreferences` (almacenamiento local)
- La app sigue funcionando
- Cuando vuelva la conexión, se sincroniza con MongoDB

---

## 🐛 Solucionar problemas

### "Connection refused" en Flutter
- ¿El backend está corriendo? → `npm run dev`
- ¿Usas la URL correcta? → Chequea `pc_service.dart`
- Para Android: usa `10.0.2.2` en lugar de `localhost`

### Error de MongoDB
- ¿MongoDB está corriendo? → Abre MongoDB Compass
- ¿La contraseña es correcta en `.env`?

### Número de serie duplicado
- El número de serie debe ser único
- Si intentas agregar uno existente, MongoDB rechazará

---

## 📋 Checklist de implementación

- [ ] Instalé `http` en pubspec.yaml
- [ ] Creé `lib/services/pc_service.dart`
- [ ] Actualicé `add_pc_screen.dart`
- [ ] Actualicé `inventory_screen.dart`
- [ ] Creé el backend Node.js
- [ ] Instalé MongoDB (local o Atlas)
- [ ] Configuré `.env` en el backend
- [ ] Backend está corriendo en puerto 3000
- [ ] Actualicé URL en `pc_service.dart`
- [ ] Probé desde Postman
- [ ] Probé desde la app Flutter

---

## 🎯 Próximos pasos (opcional)

1. **Autenticación**: Añade login con JWT
2. **Validación**: Más validaciones en backend
3. **Búsqueda**: Buscar PCs por ubicación/responsable
4. **Gráficas**: Mostrar estadísticas del inventario
5. **Exportar**: Exportar a Excel/PDF

---

¿Necesitas ayuda? Verifica:
- Los archivos en `lib/services/`
- El estado del backend
- La conexión a MongoDB
