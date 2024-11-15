import React, {useState, useEffect} from 'react';
import logo from '../images/gamematch.png';
import {MenuHamburgesa} from '../components/MenuLateral';
import {FooterComp} from '../components/Footer';
import {useNavigate} from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import axios from 'axios';


function Recomendador(){
  const [GenerosVideojuegos, setGenerosVideojuegos] = useState([]);
  const [generoSeleccionado, setGeneroSeleccionado] = useState('');
  const [PlataformasSeleccionables, setPlataformasSeleccionables] = useState([])
  const [botonOpen, setBotonOpen] = useState(false);
  const id_usuario = localStorage.getItem('id_usuario')
  const [anyo, setAnyo] = useState([]);
  const [anyoElegido, setAnyoElegido] = useState(0);
  const [videojuegosRecomendados, setVideojuegosRecomendados] = useState([]);
  const [plataformasSeleccionadas, setPlataformasSeleccionadas] = useState([]);
  const [ActivarSlider, setActivarSlider] = useState(false); 
  const [errorForm, setErrorForm] = useState("")
  const navigate = useNavigate();
  const [bienvenida, setBienvenida] = useState([]);
  const token = localStorage.getItem('auth_token');


  console.log(id_usuario)
  console.log('Token:', token)

  /*Si no existe autenticado, se denegará el permiso a esta página*/
  if (!token) {
    console.log('Token no identificado, redirigiendo al login...');
    window.location.href = '/';
  } else {
    fetch('http://localhost:8000/api/NombreUsuario/', {
      method: 'GET',
      headers: {
        'Authorization': `Token ${token}`, 
        'Content-Type': 'application/json',
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('No autorizado');
      }
      return response.json();
    })
    .then(data => {
      console.log('Datos recibidos:', data);
      if (data.nombre_usuario) {
        setBienvenida(`Bienvenido, ${data.nombre_usuario}`)
      }
    })
    .catch(error => {
      console.error('Error al hacer la solicitud:', error);
    });
  }

  /*Importar generos de videojuegos para elegir en el formulario de selección*/
  useEffect(() => {
    const mostrarGenerosVideojuegos = async () => {
        try {
            const response = await axios.get('http://localhost:8000/api/GenerosVideojuegos/'); 
            setGenerosVideojuegos(response.data); 
        } catch (error) {
            console.error('Error al extraer generos de videojuegos:', error);
        }
    };

    mostrarGenerosVideojuegos();
}, []);

  /*Importar años de lanzamiento de videojuegos para seleccionar en el botón deslizante (slider)*/
  useEffect(() => {
    fetch('http://localhost:8000/api/YearsVideojuegos/')
    .then(response => {
      if (!response.ok) {
        throw new Error('Error en la respuesta del servidor');
      }
      return response.json();  
    })
      .then(data => {
        setAnyo(data["Años en que se lanzaron los videojuegos registrados"]);  
        setAnyoElegido(data["Años en que se lanzaron los videojuegos registrados"][0]);  
      })
      .catch(error => {
        console.error('Error al obtener los años:', error);
      });
  }, []);

  const changeCollapse = () => {
    setBotonOpen(!botonOpen); 
  };

  /*Importar generos plataformas de videojuegos para elegir en el formulario de selección múltiple*/
  useEffect(() => {
  const fetchPlataformas = async () => {
      try {
          const response = await fetch('http://localhost:8000/api/PlataformasSel/'); 
          const data = await response.json();
          setPlataformasSeleccionables(data['Las plataformas seleccionables son']); 
      } catch (error) {
          console.error('Error al cargar plataformas:', error);
      }
  };

  fetchPlataformas();
}, []);

/*Confirmar plataforma agregada después de ser elegida por el usuario en la selección multiple*/
const handleCheckboxChange = (e) => {
  const { value, checked } = e.target;
  if (checked) {
    setPlataformasSeleccionadas(prev => [...prev, value]);
    console.log("Plataforma agregada al objeto para la recomendación:", value)
  } else {
    setPlataformasSeleccionadas(prev => prev.filter(plataforma => plataforma !== value));
    console.log("Plataforma descartada del objeto para la recomendación:", value)
  }
};

console.log(plataformasSeleccionadas) 
  

/*Confirmar el genero seleccionado por el usuario en el formulario de selección*/
const handleChange = (event) => {
  setGeneroSeleccionado(event.target.value);
  console.log('Género de videojuego seleccionado para la recomendación:', event.target.value);
};

  /*Confirmar el año de lanzamiento seleccionado por el usuario en el botón deslizante*/
  const elegirAnyo = (event) => {
    const anyoSeleccionado= event.target.value
    if (ActivarSlider){
      setAnyoElegido(anyoSeleccionado);
      console.log("Año escogido para la recomendación :", anyoSeleccionado);
    }
    else {
      console.log("Botón deslizante desactivado, sin año escogido");
      anyoElegido('')
      setAnyoElegido(anyoElegido);
    }
  };

  /*Controlar cambio activar/desactivar del botón deslizante*/
  const SliderControl = () => {
    setActivarSlider(!ActivarSlider);
  };

  /*Cuando el usuario complete alguno o todos los formularios, se comprobara si el objeto esta poblado de videojuegos
  Si contiene, se redigirá a la página donde se presentará a Lista de Cartas de recomendaciones*/
  useEffect(() => {
    if (videojuegosRecomendados && Array.isArray(videojuegosRecomendados)) {
      console.log("Candidatos para la lista de recomendaciones:", videojuegosRecomendados);
      if (videojuegosRecomendados.length > 0) {
        console.log("Traspasando lista de videojuegos recomendados....");
        navigate('/ListaRecomendaciones', 
        {
          state: {videojuegosRecomendados}
        });
      } else {
        console.log("No hay videojuegos recomendados");
      }
    } else {
      console.error("videojuegosRecomendados no es un array válido:", videojuegosRecomendados);
    }
  }, [videojuegosRecomendados]);

  /*Función para retornar los valores elegidos del formulario para generar recomendaciones*/
  /*Si no se completa un formulario como minimo, se informará mediante un mensaje*/
  /*Si el usuario ha completado formularios pero la el objeto de videojuegos no esta poblado,
  se redigirá a una página donde le informe que no se ha encontrado recomendaciones con las opciones elegidas*/
  const handleSubmit = (e) => {

    e.preventDefault(); 

    if (!ActivarSlider && generoSeleccionado==="" && plataformasSeleccionadas.length===0){
    console.error("Porfavor, selecciona minimo 1 filtro");
    setErrorForm("Advertencia: Tienes que rellenar como minimo 1 filtro para obtener tus recomendaciones");
    return;
    }
    else {
      console.log("Requisito minimo cumplido, listo para generar tus recomendaciones")
      setErrorForm()
    }

    const filtros = {
      genero: generoSeleccionado.trim(),
      anyo: ActivarSlider ? anyoElegido : '',
      plataformas: plataformasSeleccionadas,
    };
    
    fetch(`http://localhost:8000/api/RecomendacionVideojuegos/?genero=${filtros.genero}&anyo=${filtros.anyo}&plataforma=${filtros.plataformas.join(',')}`, {
      method: 'GET',
      headers: {
        'Authorization': `Token ${token}`,
        'Content-Type': 'application/json',
      },
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Error! No hay respuesta de la API');
      }
      return response.json();
    })
    .then(data => {
      console.log(data)
      const lista_recomendacion= data["Recomendación de videojuegos para el usuario"];
      setVideojuegosRecomendados(lista_recomendacion);
      if (!lista_recomendacion){
        console.log("No se han encontrado videojuegos");
        navigate('/SinRecomendaciones');
      }
    })
    .catch(error => console.error('Error! No se han obtenido recomendaciones:', error));
  } 
  



return (
        <> 
        <header className="header">
          <img src={logo} id="logo" alt="logo"/>
          <span>{bienvenida}</span>
        </header>

        <div className="iconos">
          <br></br>
            <MenuHamburgesa />
        </div>
        
        <div className="Cuerpo">
          <h1>¡Busca tu proximo videojuego aquí!</h1>
          <p>Ajusta los filtros a tu propio gusto y te presentaremos tu carta del videojuego recomendado para ti</p>
          {errorForm && (
            <span>{errorForm}</span>
          )}
            <div className="boton">
            <form onSubmit={handleSubmit}>
            <a className="btn btn-primary" data-bs-toggle="collapse" href="#collapseExample" role="button" aria-expanded={botonOpen ? "true" : "false"} aria-controls="collapseExample" onClick={changeCollapse}>
            {botonOpen 
                  ? "Pulsa aquí para cerrar el listado de filtros de búsqueda"
                  : "Pulsa aquí para abrír el listado de filtros de búsqueda"}
            </a>

            <div className="collapse" id="collapseExample">
              <div className="card card-body">
                
                <div className="form-group">
                  <label htmlFor="GenerosVideojuegos">Género</label>
                  <select className="form-control" id="GenerosVideojuegos" name="GenerosVideojuegos" value={generoSeleccionado} onChange={handleChange}>
                    <option>Selecciona un género de videojuego</option>
                    {GenerosVideojuegos.map((genero, index) => (
                            <option key={index} value={genero}>
                              {genero}
                            </option>
                          ))}
                  </select>
                </div>
                <label className="form-label" htmlFor="anyo">Año</label>
                  <div data-mdb-range-init className="range">
                    <input type="range" className="form-range" name="anyo" id="anyo" min={Math.min(...anyo)} max={Math.max(...anyo)} value={anyoElegido} step={1} onChange={elegirAnyo} disabled={!ActivarSlider}/>
                  </div>
                  <p>{anyoElegido}</p>
                  <button id="control-slider" type="button" onClick={SliderControl}>
                    {ActivarSlider ? 'Desactivar' : 'Activar'}
                  </button>
                  <div>
                  <label>Consola/Plataforma</label>
                  <br/>
                  {PlataformasSeleccionables && PlataformasSeleccionables.length > 0 && PlataformasSeleccionables.map((plataforma) => (
                    <div className="form-check form-check-inline" key={plataforma.id_plataforma}>
                      <input className="form-check-input" type="checkbox" id={`plataforma-${plataforma.id_plataforma}`} value={plataforma.nombre_plataforma} onChange={handleCheckboxChange}/>
                      <label className="form-check-label" htmlFor={`plataforma-${plataforma.id_plataforma}`}>{plataforma.nombre_plataforma}</label>
                    </div>
                    ))}
                    </div>
    
              </div>
          
          </div>
          <br></br>

          <button type="submit" className="Recomendar">
            Generar recomendación
          </button>
          
          </form> 
           </div>
           
        </div>
        

        <FooterComp/>

        </>
      );
}


export default Recomendador;