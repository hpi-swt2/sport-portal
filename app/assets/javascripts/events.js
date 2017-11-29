// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

document.addEventListener("DOMContentLoaded", function() {
    $("#event_startdate").datepicker({
       onSelect: function() {
           $(this).change();
       }
    });

    $("#event_startdate").on("change", changeDur);


    $("#event_enddate").datepicker({
        onSelect: function() {
            $(this).change();
        }
    });

    $("#event_enddate").on("change", changeDur);

    function changeDur()
    {
        var start = $("#event_startdate").val();
        var end = $("#event_enddate").val();
        if(start != "" && end != "") {
            data1 = end.split("/");
            var enddate = new Date(data1[2],data1[1]-1,data1[0]);

            data2 = start.split("/");
            var startdate = new Date(data2[2],data2[1]-1,data2[0]);

            diff = Math.round((enddate-startdate)/(1000*60*60*24)) + 1;

            if (diff <= 0){
                diff = "";
            }
            $("#event_duration").val(diff);
        }
    }

    $("#event_duration").on("change", function(){
       var start = $("#event_startdate").val();
       if(start != "") {
           data1 = start.split("/");
           var startdate = new Date(data1[2],data1[1]-1,data1[0]);
           startdate.setDate(startdate.getDate() + parseInt(this.value - 1));

           var dd = startdate.getDate();
           var mm = startdate.getMonth() + 1;
           var y = startdate.getFullYear();
           var formattedDate = dd + '/' + mm + '/' + y;
           $("#event_enddate").val(formattedDate);
       }
    });

    displayTypeField();

    // Display Game Mode field conditionally in create events form
    $("#event_type, #tournament_type, #league_type").change(function() {
        displayTypeField();
    });

    function displayTypeField() {
        var option = $("#event_type, #tournament_type, #league_type").val();
        var league = $("#league-game-mode");
        var tournament = $("#tournament-game-mode");

        if (option == "Tournament") {
            $(tournament).show();
            $(league).hide();
        } else if (option == "League") {
            $(league).show();
            $(tournament).hide();
        }
    }
});