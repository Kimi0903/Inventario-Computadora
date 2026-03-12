const mongoose = require('mongoose');
const pool = require('../dbConfig');


const PcSchema = new mongoose.Schema({
  ubicacion: String,
  responsable: String,
  puesto: String,
  tipoEquipo: String,
  marca: String,
  numeroSerie: String,
  discoDuro: String,
  memoriaRam: String,
  windows: String,
  tarjetaGrafica: String,
  contrasena: String,
  correoInstitucional: String,
  clave: String,
},);

module.exports = mongoose.model('Pc', PcSchema);
