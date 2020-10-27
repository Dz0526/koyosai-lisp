function refreshNumber(){
    fetch("https://koyosai-lisp.tk/api",{
        mode: "cors"
      }).then((responce)=>{
        console.log(responce);
        if(!responce.ok){
            throw new error("fetch failed");
        }
        return responce.json();
    })
    .then((data)=>{
        console.log(data);
        $("#js_people_number").html(`${data.number}`);
        if(data.number<=5){
            $("#js_people_number").css("color","green");
        }
        else if(data.number<=8){
            $("#js_people_number").css("color","gold");
        }
        else{
            $("#js_people_number").css("color","red");
        }
    })
    .catch((e)=>{
        console.error(e);
    });
}
window.onload=()=>{
    refreshNumber();
    setInterval(refreshNumber,60000); //1request/min
}