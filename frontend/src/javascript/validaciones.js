import $ from 'jquery';
import 'jquery-validation';
import React, { useEffect } from 'react';

$.validator.addMethod("contrasenya_segura", function(value){ 
    let contrasenyaLetra = false;
    let contrasenyaNumero = false;
    let contrasenyaCaracter = false;

    console.log("La contraseña es", value);

    for (let i=0; i<value.length; i++){
    console.log("Caracter actual:", value[i]);

        if(/\d/.test(value[i])){
            contrasenyaNumero=true;
            console.log("La contraseña tiene número, requisito cumplido")
        }
        else if(/[a-zA-Z]$/.test(value[i])){
            contrasenyaLetra=true;
            console.log("La contraseña tiene letra, requisito cumplido")
        }    
        else if(/[^a-zA-Z0-9]/.test(value[i])){
            contrasenyaCaracter=true;
            console.log("La contraseña tiene caracter especial, requisito cumplido")
        }
    }


    if (contrasenyaLetra===true && contrasenyaNumero===true && contrasenyaCaracter===true) {
        console.log("La contraseña es segura, validada") 
         return true; 
    }
    else if (contrasenyaLetra===true && contrasenyaNumero===false && contrasenyaCaracter===false){
        console.log("Tu contraseña debe tener por lo menos un número y caracter especial");
    }
    else if (contrasenyaLetra===true && contrasenyaNumero===true && contrasenyaCaracter===false){
        console.log("Tu contraseña debe tener por lo menos un caracter especial");
    }
    else if (contrasenyaLetra===false && contrasenyaNumero===true && contrasenyaCaracter===true){
        console.log("Tu contraseña debe tener por lo menos una letra");
    }
    else if (contrasenyaLetra===false && contrasenyaNumero===false && contrasenyaCaracter===true){
        console.log("Tu contraseña debe también tener letra y número");
    }
    else if (contrasenyaLetra===true && contrasenyaNumero===false && contrasenyaCaracter===true){
        console.log("Tu contraseña debe también tener número");
    }
    else if (contrasenyaLetra===false && contrasenyaNumero===true && contrasenyaCaracter===false){
        console.log("Tu contraseña debe tener por lo menos una letra y carácter especial");
    }
    else {
        console.log("La contraseña no es segura")
        return "La contraseña no cumple con nuestra politica de seguridad "; 
    }
         
},"Tu contraseña debe tener por lo menos una letra, un número y un carácter especial"
);

const Validador = () => {
    useEffect(() => {
    console.log("Validación de formulario activada");
    $("#formulario-registro").validate({  
        ignore: ':hidden:not(select)',
        rules:{
            nombre_usuario: {
                required: true,
                minlength: 5,
                maxlength: 10 
            },
            correo_electronico: {
                required: true,
                email: true
            },
            genero: {
                required: true,
            },
            fecha_nacimiento: {
                required: true,
                date: true
            },
            nacionalidad: {
                required: true
            },
            password: {
                required: true,
                minlength: 7,
                contrasenya_segura: true 
            },
            confirma_contrasenya:{
                required: true,
                minlength: 7,
                equalTo: "#password"
            },
            terminos_condiciones:{
                required: true
            },
        },
        messages:{
            nombre_usuario: {
                required: "Ingrese un nombre de usuario",
                minlength: "Su nombre de usuario es demasiado corto",
                maxlength: "Su nombre de usuario no debe ser muy larga"
            },
            correo_electronico: {
                required: "Ingrese un correo electrónico porfavor",
                email: "Ingrese un correo electrónico valido"
            },
            genero: {
                required: "Porfavor selecciona tu género"
            },
            fecha_nacimiento: {
                required: "Ingresa tu fecha de nacimiento porfavor",
                date: "Ingrese una fecha válida"
            },
            nacionalidad: {
                required: "Porfavor, selecciona tu nacionalidad"
            },
            password: {
                required: "Debes ingresar una contraseña",
                minlength: "Tu contraseña es muy corta"
            },
            confirma_contrasenya: {
                required: "Debes ingresar una contraseña",
                minlength: "Tu contraseña es muy corta",
                equalTo: "Las contraseñas ingresadas deben ser iguales"
            },
            terminos_condiciones: {
                required: "Debes aceptar los terminos y condiciones de la aplicación"
            }
        },
        submitHandler: (form) => {
            const data = Object.fromEntries(new FormData(form));
            console.log('Validado', data);
        },  
    });
});
}
          

export default Validador;
