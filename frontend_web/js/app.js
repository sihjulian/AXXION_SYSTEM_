// app.js - punto de entrada JavaScript
document.addEventListener('DOMContentLoaded', function(){
  console.log('AXXION frontend cargado');
  // ejemplo: detectar clicks en mockups
  document.body.addEventListener('click', (e)=>{
    if(e.target.matches('[data-demo]')){
      alert('Elemento demo pulsado: '+ e.target.dataset.demo);
    }
  });
});



fetch ('http://localhost:8000/api/usuarios')
.then(Response => Response.json())
.then(data => console.log(data))
