import React from 'react';
import logo from '../images/gamematch.png';
import {FooterComp} from '../components/Footer';
import reloj from '../images/reloj_Arena.jpg';
import {MenuHamburgesa} from '../components/MenuLateral';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import { useNavigate } from 'react-router-dom';


function NoRecomendacion(){
const token = localStorage.getItem('auth_token');
const navigate = useNavigate();


if (!token || token==='null'){
  console.log("Usuario no identificado, acceso denegado");
  console.log("Redirigiendo al incicio...")
  console.log(token)
  window.location.href = '/';
}
else{
  console.log("Usuario identificado");
  console.log(token)
}



const Regreso_Inicio = () =>{
    navigate('/Recomendador')
}

return (
          <> 
          <header className="header">
          <img src={logo} id="logo" alt="logo" />
        </header>

        <div className="iconos">
          <nav>
            <MenuHamburgesa />
          </nav>
        </div>

          <div className="ListaVacia">
            <h1>Ups! Hasta aquí llego tu búsqueda</h1>
            <br></br>
            <img id="reloj" alt="reloj" src={reloj} height="370px"/>
            <br></br>
            <h6>Reajusta tus filtros y buscas otras recomendaciones para seguir usando nuestros servicios</h6>
            <br></br>
            <button type="submit" onClick={Regreso_Inicio} id="Volver">Volver al inicio</button>
            <br></br>
            <br></br>
            <br></br>




          </div>


 
 


          <FooterComp/>
        </>

        )
}
  
export default NoRecomendacion;