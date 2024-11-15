import React, {useState, useEffect} from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import {useNavigate} from 'react-router-dom';
import logo from '../images/gamematch.png';
import {FooterComp} from '../components/Footer';
import axios from 'axios';
import { CSSTransition } from 'react-transition-group';
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"></link>

function CuestionarioPerfil() {
  
const [importaPreguntas, setImportaPreguntas] = useState([]);
const [indicePregunta, setIndicePregunta] = useState(0);
const [respuestas, setRespuestas] = useState(Array(importaPreguntas.length).fill(null));
const [mostrarPregunta, setMostrarPregunta] = useState(false);
const [importarAlternativas, setImportarAlternativas] = useState([]);
const [mensajeError, setMensajeError] = useState('');
const navigate = useNavigate();
const [enviadas, setEnviadas] = useState(false);
const id_usuario = localStorage.getItem('id_usuario')
const token = localStorage.getItem('auth_token');

/*Importar preguntas de factores motivacionales para responder en el cuestionario*/
useEffect(() => {
  const mostrarPreguntas = async () => {
    try {
      const response = await axios.get('http://localhost:8000/api/preguntas_motivacion/');
      setImportaPreguntas(response.data);
      setRespuestas(Array(response.data.length).fill(null));
      setMostrarPregunta(true); 
    } catch (error) {
      console.error("Error al extraer preguntas de factor motivacional desde la API", error);
    }
  };
  mostrarPreguntas();
}, []);

  /*Importar alternativas para las preguntas del cuestionario (en escala Likert)*/
  useEffect(() => {
    const mostrarAlternativas = async () => {
      try {
        const response = await axios.get('http://localhost:8000/api/escala_pregunta/');
        setImportarAlternativas(response.data);
      } catch (error) {
        console.error("Error al extraer las opciones de las preguntas desde la API:", error);
      }
    };
    mostrarAlternativas();
  }, []);


  /*Función para pasar de pregunta en el cuestionario*/
  const siguientePregunta = () => {
  let CuestionarioCompletado = true;

  if (indicePregunta < importaPreguntas.length - 1) {
    setIndicePregunta(indicePregunta + 1);
  }
  else{
    for (let indice = 0; indice < respuestas.length;  indice++) {
      if (respuestas[indice] === null) {
      CuestionarioCompletado = false;
    break;
  }
  }

  /*Verificar si el cuestionario se ha completado al llegar a la última pregunta*/
  /*Si no está completado, se le informará al usuario que debe rellenar las preguntas que no ha contestado 
  para proseguir*/ 
  if (CuestionarioCompletado) {
  console.log("El cuestionario ha sido completo, listo para enviar y guardarse")
  handleSubmit();
  } else {
  console.log("Cuestionario no completado, rellenar preguntas sin respuestas")  
  setMensajeError("Debes completar el cuestionario para avanzar")
  }
  }
};

  /*Función para retroceder de pregunta en el cuestionario*/ 
  const anteriorPregunta = () => {
  if (indicePregunta < (importaPreguntas.length+1) && indicePregunta>=1 ) {
    setIndicePregunta(indicePregunta - 1);
  }
}; 
    
  /*Confirmar respuesta elegida del usuario en una pregunta del cuestionario*/
  const manejarCambio = (valor) => {
      const nuevasRespuestas = [...respuestas];
      nuevasRespuestas[indicePregunta] = valor;

      console.log(`La pregunta ${importaPreguntas[indicePregunta].id_pregunta} ha sido calificada con la alternativa: ${valor}`);


      setRespuestas(nuevasRespuestas);
};


  /*Evitar que se envie el formulario por defecto*/
  async function handleSubmit(e) {

  if (e){  
  e.preventDefault();
  }

  if (enviadas) {
    return;
  }

  /*Evitar error en caso de que una pregunta no haya sido contestada*/
  if (respuestas.some(respuesta => respuesta === null)) {
    return; 
  }


  /*Verificar que el usuario haya creado su cuenta como paso previo*/
  if (!id_usuario) {
    console.error("No se encontró el ID del usuario en localStorage.");
  } else {
  console.log("ID del usuario:", id_usuario);
  } 

  if (!token) {
    console.error("No se encontró el token en localStorage.");
    setMensajeError("No se encontró el token de autenticación.");
    return;
  }

  console.log("ID del usuario:", id_usuario);
  console.log("Token recuperado:", token);

  setEnviadas(true);

  /*Función que permite registrar las respuestas del cuestionario del usuario*/
  /*Si esta completado, se creará su Perfil de Jugador y ya tendrá la posibilidad de solicitar sus recomendaciones*/
  const recorrido = respuestas.map((escala, indice) => {
    const data = {
        usuario: id_usuario,
        pregunta: importaPreguntas[indice].id_pregunta,
        escala,
    };    
  
    console.log("Datos a enviar:", data); 
  
    return fetch('http://localhost:8000/api/motivacion_jugador/', {
        method: "POST",
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
    })
    .then(response => {
      if (!response.ok) {
          throw new Error(`Error en la respuesta del servidor: ${response.statusText}`);
      }
      return response.json();
  });
    });
  
    try {
      const resultados = await Promise.all(recorrido);
      console.log("Respuestas enviadas:", resultados);   
      navigate('/Recomendador');
    } catch (error) {
        console.error("Error al enviar las respuestas:", error);
        setMensajeError("Ocurrió un error al enviar las respuestas.");
    } finally {
      setEnviadas(false)
    }
  }

  
  
return (
        <>
        <header className="header">
        <img src= {logo} id="logo" alt="logo"/>
        </header>

        <form onSubmit={handleSubmit}>
        {importaPreguntas.length > 0 ? (
        <div className="cuestionario">
            <h1>Crea tu perfil de Usuario</h1>
            <span>Responde el siguiente cuestionario: </span>
            <div className="contador">
            <span>{indicePregunta+1}/{importaPreguntas.length}</span>
            </div>
            <span className="mensaje_cuestionario">{mensajeError}</span>
            <div className="cuadro">
            <CSSTransition
              in={mostrarPregunta}
              timeout={500}
              classNames={"pregunta"}
              unmountOnExit
              >
              <h6>{importaPreguntas[indicePregunta].pregunta}</h6>
              </CSSTransition>
              
            {importarAlternativas.length>0}
            <ul className="alternativas_cuestionario">
              {importarAlternativas.map((opcion) => (
              <li key={opcion.id_escala}>
              <label>
              <input
              type="checkbox"
              className={opcion.id_escala}
              name={`pregunta-${indicePregunta}`}
              value={opcion.id_escala}
              checked={respuestas[indicePregunta] === opcion.id_escala}
              onChange={() => manejarCambio(opcion.id_escala)}
              />
              <span className="custom-checkbox-label">{opcion.escala}</span>
              </label>
              </li>
              ))}
          </ul>
          </div>
          <div className="secuencia_cuestonario">
          <button type="button" onClick={anteriorPregunta} className='retroceder_cuestionario'>
                Anterior
              </button>
              <button type={indicePregunta === importaPreguntas.length-1 ? 'submit' : 'button'} onClick={siguientePregunta} className='avanzar_cuestionario'>
              {indicePregunta === importaPreguntas.length-1 ? 'Enviar respuestas' : 'Siguiente'}
              </button>

            </div>
      </div>
    ) : (
      <p>Cargando cuestionario de factores motivacionales...</p>
  )}
  </form>   

    

  
        
    

      < FooterComp />
      </>
);
}



 export default CuestionarioPerfil;
