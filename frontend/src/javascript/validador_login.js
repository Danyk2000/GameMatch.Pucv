import $ from 'jquery';
import 'jquery-validation';
import React, { useEffect } from 'react';

const ValidadorLogin = () => {
    useEffect(() => {
    $("#form-login").validate({  
        ignore: ':hidden:not(select)',
        rules: {
            username: {
                required: true,
                minlength: 5,
                maxlength: 10 
            },
            password: {
                required: true,
                minlength: 7
            }
        },
        messages: {
            username: {
                required: "Ingrese un nombre de usuario",
                minlength: "Su nombre de usuario es demasiado corto",
                maxlength: "Su nombre de usuario no debe ser muy larga"
            },
            password: {
                required: "Debes ingresar una contraseña",
                minlength: "Tu contraseña es muy corta"
            }
        },
        submitHandler: (form) => {
            const data = Object.fromEntries(new FormData(form));
            window.location.href = "Recomendador";
            console.log('Validado');
            console.log(data);
        }
    });
});
}

export default ValidadorLogin;