import React, {useState} from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import logo from '../images/gamematch.png';
import {useNavigate} from 'react-router-dom';
import {FooterComp} from '../components/Footer';
import ValidadorLogin from '../javascript/validador_login';
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"></link>


function Principio() {
  const [nombre_usuario, setNombreUsuario] = useState("");
  const [password, setPassword] = useState("");
  const [mensajeError, setMensajeError] = useState("");

  const navigate = useNavigate();

  /*Función para validar la vista de inicio de sesión*/
  function handleSubmit(event) {
    event.preventDefault();
    const data = {
      nombre_usuario,
      password
    };

    fetch('http://localhost:8000/api/Login/', {
      method: "POST",
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    })
      .then(response => {
      if (!response.ok) {
        throw new Error(`Error en la respuesta: ${response.statusText}`);
      }
      return response.json();
    })
      .then(result => {
        console.log(result)
        if (result.token) {
          console.log(result.message);
          localStorage.setItem('auth_token', result.token); 
          localStorage.setItem('id_usuario', result.id_usuario)
          console.log("id", result.id_usuario)
          console.log("El token es ",result.token)
          navigate('/Recomendador');
        }
        else {
          setMensajeError(result.message || "Error al iniciar sesión");
        }
      })
      .catch(error => {
        setMensajeError("Error! Nombre de usuario y/o contraseña incorrecta(s)");
        console.log(error);
      })
  };


 
return (
      <> 
      <header className="header">
        <img src= {logo} id="logo" alt="logo"/>
        </header>


      <div className="Cuerpo">
  
          <h1>¡Bienvenido a GameMatch!</h1>
          <span>"La recomendación perfecta, para el jugador perfecto"</span>

          <div className="mb-3 error-message">
            {mensajeError && <p className="text-danger">{mensajeError}</p>}
          </div>

          <div className='formu'>
            <form id="form-login" className="form-login" onSubmit={handleSubmit}>
              <br></br>
              <input type="text" className="form-control" id="username" name="username" placeholder="Nombre de usuario" onChange={e => setNombreUsuario(e.target.value)} required/>
              <br></br>
              <input type="password" className="form-control" id="password" name="password" placeholder="Contraseña" onChange={e => setPassword(e.target.value)} required/>   
              <br></br>
              <button id="login" type="submit">Iniciar Sesión</button>

            </form>
            <br></br>
          <a href="recuperacion" id="recuperacion" style={{ color: 'black' }}>¿Olvidaste la contraseña? Ingresa aquí</a>
          </div>
        <a href="Registrarse" margin-top="400px">Registrate aquí</a>  

        </div>

        

        < FooterComp />
        </>
    );

  }

export default Principio;
