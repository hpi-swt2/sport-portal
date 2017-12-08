$( document ).on('turbolinks:load', function() {
    $('#event_deadline').datepicker({ autoclose: true});
    $('#event_startdate').datepicker({ autoclose: true});
    $('#event_enddate').datepicker({ autoclose: true});

    $("#event_duration").val("");
  

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
            diff = calcDateDiff(start,end);
            if (diff <= 0){
                diff = "";
            }
            $("#event_duration").val(diff);
        }
    }

    function calcDateDiff(startdatestr, enddatestr)
    {
      var start = new Date(startdatestr);
      var end = new Date(enddatestr);

      return  Math.round((end-start)/(1000*60*60*24)) + 1;
    }

    $("#event_duration").on("change", function(){

       var start = $("#event_startdate").val();
       if(start != "") {
           var startdate = new Date(start);
           startdate.setDate(startdate.getDate() + parseInt(this.value - 1));

           var dd = startdate.getDate();
           var mm = startdate.getMonth() + 1;
           var y = startdate.getFullYear();
           var formattedDate = y + '-' + mm + '-' + dd;
           $("#event_enddate").val(formattedDate);
       }
    });


    displayTypeField();

    // Display Game Mode field conditionally in create events form
    $("#event_type").on('change', function() {
        displayTypeField();
    });

    function disableField(field){
        $(field).find("select").attr("disabled", "disabled");
        $(field).hide();
    }

    function enableField(field){
        $(field).find("select").removeAttr("disabled");
        $(field).show();
    }

    function enableDates(){
        var enddatefield = $("#event_enddate_div");
        var startdatefield = $("#event_startdate_div");
        var durationfield = $("#event_duration_div");
        var deadlinefield = $("#event_deadline_div");

        enableField(enddatefield);
        enableField(startdatefield);
        enableField(durationfield);
        enableField(deadlinefield);
    }

    function disableDates(){
        var enddatefield = $("#event_enddate_div");
        var startdatefield = $("#event_startdate_div");
        var durationfield = $("#event_duration_div");
        var deadlinefield = $("#event_deadline_div");

        disableField(enddatefield);
        disableField(startdatefield);
        disableField(durationfield);
        disableField(deadlinefield);
    }

    function displayTypeField() {
        var option = $("#event_type").val();
        var league = $("#league-game-mode");
        var tournament = $("#tournament-game-mode");
        var playertypes = $("#event_player_types");
        var metric = $("#event_metric_div");
        var initialvalue = $("#event_initial_value_div");

        if (option == "Tournament") {
            enableField(tournament);
            enableDates();
            enableField(playertypes);
            disableField(metric);
            disableField(initialvalue);

            disableField(league);

        } else if (option == "League") {
            enableField(league);
            enableDates();
            enableField(playertypes);

            disableField(metric);
            disableField(initialvalue);
            disableField(tournament)
        } else {
            disableField(league);
            disableField(tournament);
            disableField(playertypes);
            enableField(metric);
            enableField(initialvalue);
            disableDates();
        }
    }
});