import React, { useState, useEffect} from 'react';
import logo from '../images/gamematch.png';
import { Link, useNavigate} from 'react-router-dom';
import {FooterComp} from '../components/Footer';
import axios from 'axios';
import 'bootstrap/dist/css/bootstrap.min.css';
import Validador from '../javascript/validaciones';



  function Registrarse() {
    const [nombre_usuario, setNombreUsuario] = useState("");
    const [correo_electronico, setCorreoElectronico] = useState("");
    const [fecha_nacimiento, setFechaNacimiento] = useState("");
    const [password, setPassword] = useState("");
    const [nacionalidad, setNacionalidad] = useState("");
    const [genero, setGenero] = useState("");
    const [importaNacionalidades, setImportaNacionalidades] = useState([]);
    const [importaGeneros, setImportaGeneros] = useState([]);
    const [mensajeAdvert, setMensajeAdvert] = useState("");
    const navigate = useNavigate();

    /*Importar nombres de nacionalidades desde su propia vista para su selección en el formulario de registro*/
    useEffect(() => {
      const mostrarNacionalidades = async () => {
        try {
          const response = await axios.get('http://localhost:8000/api/nacionalidad/');
          setImportaNacionalidades(response.data);
        } catch (error) {
          console.error("Error al extraer nacionalidades de países latinoamericanos desde la base de datos:", error);
        }
      };
      mostrarNacionalidades();
    }, []);

    /*Importar nombres de generos de persona desde su propia vista para su selección en el formulario de registro*/
    useEffect(() => {
      const mostrarGeneros = async () => {
        try {
          const response = await axios.get('http://localhost:8000/api/genero/');
          setImportaGeneros(response.data);
        } catch (error) {
          console.error("Error al extraer generos de persona desde la base de datos", error);
        }
      };
      mostrarGeneros();
    }, []);


      /*Función que permite retornar los datos completados en el formulario y guardarlos para registrar al usuario en el backend*/
      async function handleSubmit(e) {
        e.preventDefault()
        const data = {
            nombre_usuario: nombre_usuario,
            correo_electronico: correo_electronico,
            genero: genero,
            fecha_nacimiento: fecha_nacimiento,
            nacionalidad: nacionalidad,
            password: password,
        };    

        /*Comprobar que el formulario haya sido completado*/
        if (!data.nombre_usuario || !data.correo_electronico || data.genero==="" || !data.fecha_nacimiento || data.nacionalidad==="" || !data.password) {
          console.error("Por favor, completa los formularios.");
          setMensajeAdvert("Completa el formulario, todos los campos son obligatorios");
          return;
      }

        console.log("Datos a enviar:", data); 

        fetch('http://localhost:8000/api/Registrarse/', {
            method: "POST",
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
        })
        .then(response => {
          console.log("Respuesta del servidor:", response); 
          return response.json();
      })
      .then(result => {
          console.log("Resultado de la respuesta:", result);
          if (result.success) {
              localStorage.setItem('id_usuario', result.id_usuario);
              console.log("ID del usuario guardado:", result.id_usuario);
              localStorage.setItem('auth_token', result.token);
              console.log("Token de usuario guardado:", result.token);
              console.log("Redirigiendo al cuestionario de creación de perfil...");
              navigate('/CrearPerfil');
          } else {
              console.error("¡Error! Creación de Usuario fracasada:", result.message);
          }
      })
      .catch(error => {
          console.error("Error en la solicitud:", error.response ? error.response.data : error.message);;
      });
    };
      
    return (
      <>
        <header className="header">
          <Link to="/">
            <img src={logo} id="logo" alt="logo" />
          </Link>
        </header>

        <div className="Registrate">
          <h1>Registrate</h1>
          <span>{mensajeAdvert}</span>

          <form id="formulario-registro" className="formulario-registro">
          
            <div className="container">
              <div className="row justify-content-center">
                <div className="col-md-12">
                  <div className="form-group">

                    <label htmlFor="nombre_usuario">Nombre de usuario</label>
                    <div className="col-sm-20">
                      <input type="text" className="form-control" id="nombre_usuario" name="nombre_usuario" /*value={nombre_usuario}*/ placeholder="Escribe tu nombre de usuario" onChange={(e) => {setNombreUsuario(e.target.value); console.log("Usuario:", e.target.value)}} required />
                    </div>
                    <label htmlFor="correo_electronico">Correo electrónico</label>
                    <div className="col-sm-20">
                      <input type="email" className="form-control" id="correo_electronico" name="correo_electronico" /*value={correo_electronico}*/ placeholder="Escribe tu correo electrónico" onChange={(e) => { setCorreoElectronico(e.target.value); console.log("Correo:", e.target.value)}}  required />
                    </div>
                    <label htmlFor="genero">Género</label>
                    <br/>
                    <select className="form-control" id="genero" name="genero"  placeholder="Selecciona tu género" onChange={(e) => { setGenero(e.target.value); console.log("Genero:", e.target.value)}} required>
                          <option>Selecciona tu género</option>
                          {importaGeneros.map((genero) => (
                            <option key={genero.id_genero} value={genero.id_genero}>
                              {genero.nombre_genero}
                            </option>
                          ))}
                        </select>
                        <br></br>
                      <label htmlFor="fecha_nacimiento">Fecha de Nacimiento</label>
                      <div className="col-sm-20">
                        <input type="date" className="form-control" id="fecha_nacimiento" name="fecha_nacimiento" placeholder="Selecciona tu fecha de nacimiento" /*value={fecha_nacimiento}*/ onChange={(e) => { setFechaNacimiento(e.target.value); console.log("Fecha de Nacimiento:", e.target.value)}} required />
                      </div>
                    </div>
                    <div className="col-sm-20">
                      <label htmlFor="nacionalidad">País</label>
                        <select className="form-control" id="nacionalidad" name="nacionalidad" placeholder="Selecciona tu nacionalidad" /*value={nacionalidad}*/ onChange={(e) => { setNacionalidad(e.target.value); console.log("Nacionalidad:", e.target.value)}} required>
                          <option>Selecciona tu nacionalidad</option>
                          {importaNacionalidades.map((nacionalidad) => (
                            <option key={nacionalidad.id_nacionalidad} value={nacionalidad.id_nacionalidad}>
                              {nacionalidad.nacionalidad}
                            </option>
                          ))}
                        </select>
                    
                    </div>
                    <label htmlFor="password">Contraseña</label>
                    <div className="col-sm-20">
                      <input type="password" className="form-control" name="password" id="password" /*value={contrasenya}*/ placeholder="Escribe tu contraseña" onChange={(e) => { setPassword(e.target.value); console.log("Contraseña:", e.target.value)}} required />
                    </div>
                    <label htmlFor="confirma_contrasenya">Confirma tu contraseña</label>
                    <div className="col-sm-20">
                      <input type="password" className="form-control" name="confirma_contrasenya" id="confirma_contrasenya" placeholder="Vuelve a escribir la contraseña" required />
                    </div>

                    <br></br>

                    <div className="col-sm-20">
                      <input className="form-check-input" type="checkbox" id="terminos_condiciones" name="terminos_condiciones" required />
                      <label className="form-check-label" htmlFor="terminos_condiciones">Acepto los términos y condiciones de GameMatch, incluyendo la política de privacidad y las condiciones de uso.</label>
                    </div>

                    <br></br>


                  </div>

                  <br />

                </div>


              </div>

            <div id="Creacion_Cuenta">
              <button id="Crear_Cuenta" type="button" onClick={handleSubmit}>Crear Cuenta</button>
            </div>

            <Validador/>
                
            

          </form>



        </div>





        <FooterComp />


      </>
    );
  }

    
    export default Registrarse;
