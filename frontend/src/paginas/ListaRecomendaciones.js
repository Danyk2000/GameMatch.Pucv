import React, {useState, useEffect} from 'react';
import logo from '../images/gamematch.png';
import { Link, useLocation } from 'react-router-dom';
import {MenuHamburgesa} from '../components/MenuLateral';
import {FooterComp} from '../components/Footer';
import axios from 'axios';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';

function CartaRecomendacion(){
  const[mostrarOpciones, setMostrarOpciones] = useState({});
  const token = localStorage.getItem('auth_token');
  const id_usuario = localStorage.getItem('id_usuario')
  const location = useLocation(); 
  const {videojuegosRecomendados} = location.state || {}; 
  const [mensajeRecomendación, setMensajeRecomendacion] = useState({});
  const idrecomendacion_aceptada=1;
  const idrecomendacion_rechazada=2;

  console.log('ID :', id_usuario) 

  /*Si el usuario no esta identificado, no podrá ingresar a esta página*/
  if (!token || token=='null' || !id_usuario){
    console.log("Usuario no identificado, acceso denegado")
    window.location.href='/';
  }


  /*Traspasar lista de recomendaciones generadas en la página "Recomendador" en forma de objetos*/
  useEffect(() => {
  if (videojuegosRecomendados) {
    console.log("Videojuegos recomendados recibidos:", videojuegosRecomendados);
  } else {
    console.log("No se recibieron videojuegos recomendados.");
  }
}, [videojuegosRecomendados]);


  /*Garantiza la activación los botones de aceptar/rechazar antes de que el usuario eliga su decisión*/
  useEffect(() => {
    const botones = {};
    
    videojuegosRecomendados.forEach(videojuego => {
      botones[videojuego.id_videojuego] = true;  
    });
    setMostrarOpciones(botones);
  }, [videojuegosRecomendados]);

  /*En caso de que el usuario haya elegido "Aceptar Recomendación", se registrarán los datos a la api que contiene las respuestas de las cartas de recomendaciones*/
  const RecomendacionAceptada = (videojuego_id) => {  
  console.log(`La recomendación del videojuego fue aceptada!`)
  console.log("El usuario ",{id_usuario},"ha aceptado la carta del videojuego: ",{videojuego_id});

    
      setMostrarOpciones(prev => ({
        ...prev,
        [videojuego_id]: false, 
      }));

      setMensajeRecomendacion(prev => ({
        ...prev,
        [videojuego_id]: "Felicidades! Nos alegra que hayas aceptado esta carta."
      }));

      fetch(`http://localhost:8000/api/recomendacion_usuario/`, {
        method: 'POST',
        headers: {
          'Authorization': `Token ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(
          {opcion: idrecomendacion_aceptada, 
          usuario: id_usuario,
          videojuego: videojuego_id}),
      })
      .then(response => response.json())
      .then(data => {
        console.log("Datos enviados de la decisión del usuario: ", data);
        if (data.success) {
          console.log(data);
        } 
      })
      .catch(error => console.error('Error al realizar la solicitud:', error));
    }; 
    
    /*En caso de que el usuario haya elegido "Rechazar Recomendación", se registrarán los datos a la api que contiene las respuestas de las cartas de recomendaciones*/
    const RecomendacionRechazada = (videojuego_id) => {
        console.log("La recomendación del videojuego fue rechazada!")
        console.log("El usuario ",{id_usuario},"ha rechazado la carta del videojuego ",{videojuego_id });

        setMostrarOpciones(prev => ({
          ...prev,
          [videojuego_id]: false, 
        }));

        setMensajeRecomendacion(prev => ({
          ...prev,
          [videojuego_id]: "Lamentamos que hayas rechazado esta carta..."
        }));

        fetch(`http://localhost:8000/api/recomendacion_usuario/`, {
        method: 'POST',
        headers: {
          'Authorization': `Token ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({opcion: idrecomendacion_rechazada,
          usuario: id_usuario,
          videojuego: videojuego_id}),
        })
        .then(response => response.json())
        .then(data => {
        if (data.success) {
          console.log(data)
        } 
        })
      .catch(error => console.error('Error al realizar la solicitud:', error));
    }; 






return (
        <> 
        <header className="header">
        <Link to="/Recomendador">
          <img src={logo} id="logo" alt="logo"/>
          </Link>
        </header>
        

        <div className="iconos">
          <nav>
            <MenuHamburgesa />
          </nav>
        </div>

        <div className="main-container">
          <h1>Tus recomendaciones</h1>
        <div className="Carta_Recomendacion">
            <ul>
            {videojuegosRecomendados.length>0 ? (
            videojuegosRecomendados.map((videojuego, indice ) => (
            <li key={videojuego.id_videojuego}>
              <div className="carta">
                <img height="250px" width="250px" alt={videojuego.nombre} src={`http://localhost:8000/static/${videojuego.portada}.jpg`}></img>
                <h5>{videojuego.nombre}</h5>
                  <a className="btn btn-secondary" data-bs-toggle="collapse" href={`#collapseExample${videojuego.id_videojuego}`} role="button" aria-expanded="false" aria-controls={`collapseExample${videojuego.id_videojuego}`}>
                  Ver más info. de este videojuego
                  </a>
                  <div className="collapse" id={`collapseExample${videojuego.id_videojuego}`}>
                    <div className="info_carta">

                    <ul>
                    <li><span>-Género: {videojuego.genero}</span></li>
                    <li><span>-Año: {videojuego.fecha_lanzamiento}</span></li>
                    <li><span>-Desarrollado por: {videojuego.empresa_desarrollo}</span></li>
                    <li><span>-Distribuido por: {videojuego.distribuidor}</span></li>
                    </ul>

                    </div>
                  </div>



                  
            {mostrarOpciones[videojuego.id_videojuego] ? (
      

        <div className="botones">
          <button className="Aceptar" onClick={ () => RecomendacionAceptada(videojuego.id_videojuego)}>
            Aceptar Recomendación
          </button>
          <button className="Rechazar" onClick={ () => RecomendacionRechazada(videojuego.id_videojuego)}>
            Rechazar Recomendación
          </button>
        </div> 

      ) : (
      <div className="mensajeRecomendacion">
      <span>{mensajeRecomendación[videojuego.id_videojuego]}</span>
      </div>
      )}
      

        
        </div>
        </li>
        ))
      ) : (
        <p> No hay videojuegos recomendados.</p>
      )}
        </ul>


        </div>   
          
        </div>
            

        <FooterComp/>

        </>
      );
    }




  export default CartaRecomendacion;