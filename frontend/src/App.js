import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Principio from './paginas/Principio';
import CuestionarioPerfil from './paginas/CrearPerfil';
import Registrarse from './paginas/Registrarse';
import Recomendador from './paginas/Recomendador';
import CartaRecomendacion from './paginas/ListaRecomendaciones';
import NoRecomendacion from './paginas/SinRecomendaciones';
import './css/App.css';
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"></link>


function App() {
  return (
    <div className="App">
      <Router>
        <Routes>
          <Route path="/" element={<Principio />} />
          <Route path="/Registrarse" element={<Registrarse />} />
          <Route path="/CrearPerfil" element={<CuestionarioPerfil />} />
          <Route path="/Recomendador" element={<Recomendador />} />
          <Route path="/ListaRecomendaciones" element={<CartaRecomendacion />} />
          <Route path="/SinRecomendaciones" element={<NoRecomendacion/>} />
        </Routes>
      </Router>
    </div>
  );
}

export default App;