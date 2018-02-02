$( document ).on('turbolinks:load', function() {
    $('#event_deadline').datepicker({autoclose: true, startDate: new Date(), todayHighlight: true});
    $('#event_startdate').datepicker({autoclose: true, startDate: new Date(), todayHighlight: true});
    $('#event_enddate').datepicker({autoclose: true, startDate: new Date(), todayHighlight: true});

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

    // Autofill of player count for an event
    showPlayerCount();
    $("#event_player_type").on("change", showPlayerCount);

    function showPlayerCount()
    {
      switch($("#event_player_type").val())
      {
        case "single":
          $("#event_min_players_per_team").hide();
          $("#event_max_players_per_team").hide();
          break;
        case "team":
          $("#event_min_players_per_team").show();
          $("#event_max_players_per_team").show();
          break;
        default:
            $("#event_min_players_per_team").hide();
            $("#event_max_players_per_team").hide();
              break;
      }
      return false;
    }
});

