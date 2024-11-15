import React, { useState } from "react";
import { useNavigate } from 'react-router-dom';
import '../css/MenuLateral.css';

export const MenuHamburgesa = () => {
  const [burger, setBurger] = useState("burger-bar unclicked")
  const [menuBurger, setMenuBurger] = useState("menu hidden")
  const [menuClicked, setMenuClicked] = useState(false)
  const token = localStorage.getItem('auth_token');
  const navigate = useNavigate();

    const updateMenu = () => {
      setMenuClicked(!menuClicked);
      setBurger(!menuClicked ? "burger-bar clicked" : "burger-bar unclicked");
      setMenuBurger(!menuClicked ? "menu visible" : "menu hidden");
  }

  const LogOut = () => {
    if (token){
    localStorage.removeItem('auth_token', token);
    navigate('/')
    }
  };

  return (
    <div className="container-menu">
      <nav>
        <div className="burger-menu" onClick={updateMenu}>
          <div className={`burger-bar ${menuClicked ? "clicked" : "unclicked"}`} style={{ width: 50, height: 7}}></div>
          <div className={`burger-bar ${menuClicked ? "clicked" : "unclicked"}`} style={{ width: 50, height: 7}}></div>
          <div className={`burger-bar ${menuClicked ? "clicked" : "unclicked"}`} style={{ width: 50, height: 7}}></div>
        </div>
      </nav>
      <div className={`menu ${menuClicked ? "visible" : "hidden"}`}>
      <ul id="secciones">
        <h4>Secciones</h4>
        <li><a href="/Recomendador">Inicio</a></li>
        <li><a>Mi Perfil</a></li>
        <li><a>Mis recomendaciones</a></li>
        <li><a>Lista de Usuarios</a></li>
        <li><a>Los 3 Mejores</a></li>
        <li><a>El videojuego de la semana</a></li>
        <li><a>EL videojuego del mes</a></li>
        <li><a>Manual del usuario</a></li>
      </ul>

      <div className="boton_cierre">
        <button id="cerrar_sesion" onClick={LogOut}>Cerrar Sesión</button>
      </div>
      </div>
    </div>
  );
};
