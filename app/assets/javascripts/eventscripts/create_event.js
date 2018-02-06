$( document ).on('turbolinks:load', function() {
    $('#event_deadline').datepicker({autoclose: true, startDate: new Date(), todayHighlight: true, language: 'de'});
    $('#event_startdate').datepicker({autoclose: true, startDate: new Date(), todayHighlight: true, language: 'de'});
    $('#event_enddate').datepicker({autoclose: true, startDate: new Date(), todayHighlight: true, language: 'de'});

    $("#event_duration").val("");
  

    $("#event_startdate").datepicker({
       onSelect: function() {
           $(this).change();
       }
    });

    $("#event_startdate").on("change", callChanged);


    $("#event_enddate").datepicker({
        onSelect: function() {
            $(this).change();
        }
    });

    $("#event_enddate").on("change", adaptDuration);

    $("#event_gameday_duration").on("change",durationChanged);

    $("#event_game_mode").on("change",callChanged);

    $("#event_max_teams").on("change",callChanged);

    function callChanged()
    {
        adaptDuration();
        durationChanged();
    }
    function durationChanged()
    {

        var start = $("#event_startdate").val();
        var end = $("#event_enddate").val();
        var system = $("#league_game_mode").val();
        var gameday_dur =$("#league_gameday_duration").val();
        var participants = $("#league_max_teams").val();
        if(start != "" && gameday_dur != "" && system != "" && gameday_dur != undefined && system != undefined)
        {
            rounds = calcRounds(system,participants);
            var number_of_days = rounds * parseInt(gameday_dur);
            $("#event_enddate").val(addDays(start,number_of_days));

        }
        changeDur();
    }
    function adaptDuration() {


        var start = $("#event_startdate").val();
        var end = $("#event_enddate").val();
        var system = $("#league_game_mode").val();
        var gameday_dur =$("#league_gameday_duration").val();
        var participants = $("#league_max_teams").val();
        if(start != "" && end != "" && system != "" && gameday_dur != undefined && system != undefined)
        {
            rounds = calcRounds(system,participants);
            var diff = calcDateDiff(start,end);
            var gameday_duration = Math.floor(diff/rounds);
            if(diff <= 0)
            {
                $("#league_gameday_duration").val(1);
            }
            else {
                $("#league_gameday_duration").val(gameday_duration);
            }

        }
        changeDur();
    }
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

    function addDays(date, days) {
        var result = new Date(date);
        result.setDate(result.getDate() + parseInt(days));
        var dd = result.getDate();
        var mm = result.getMonth()+1;
        var y = result.getFullYear();
        var formattedDate = y + '-' + mm + '-' + dd;
        return formattedDate;
    }

    function calcDateDiff(startdatestr, enddatestr)
    {
      var splittetStart = startdatestr.split(".");
      var splittetEnd = enddatestr.split(".");
      // Es muss 1 vom Monat abgezogen werden, da diese 0 indiziert sind
      var start = new Date(splittetStart[2],splittetStart[1]-1, splittetStart[0]);
      var end = new Date(splittetEnd[2],splittetEnd[1]-1,splittetEnd[0]);
      return  Math.round((end-start)/(1000*60*60*24)) + 1;
    }

    function calcRounds(system,participants)
    {
        var num_part = parseInt(participants);
        var sys = system;
        var num_rounds;
        if(sys == "round_robin" || sys == "two_halfs")
        {
            if(num_part % 2 == 0)
            {
                num_rounds = num_part - 1;
            }
            else
            {
                num_rounds = num_part;
            }
        }
        else if (sys == "swiss")
        {
            num_rounds = (0.2 * num_part) + (1.4 * num_part);
        }

        return Math.ceil(num_rounds);
    }

    $("#event_duration").on("change", function(){

       var start = $("#event_startdate").val();
       if(start != "") {
           var splittetStart = start.split(".");
           var startdate = new Date(splittetStart[2],splittetStart[1]-1, splittetStart[0]);
           startdate.setDate(startdate.getDate() + parseInt(this.value - 1));

           var dd = startdate.getDate();
           var mm = startdate.getMonth() + 1;
           var y = startdate.getFullYear();
           if(mm < 10){
               mm = "0"+ mm;
           }
           if(dd < 10){
               dd = "0" + dd;
           }
           var formattedDate = dd + '.' + mm + '.' + y;
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
    }

    //rankinglist_game_mode -> rankinglist_initial_value
    showInitialValue();
    var initial_value_elo = "1000";
    var initial_value_trueskill = "25";
    var initial_value_win_loss = "0";
    $("#rankinglist_game_mode").on("change", showInitialValue);
    function showInitialValue()
    {
        switch($("#rankinglist_game_mode").val())
        {
            case "elo":
                $("#rankinglist_initial_value").val(initial_value_elo);
                $("#default_point_distribution").hide();
                var default_elo_change = $("#rankinglist_maximum_elo_change");
                if(default_elo_change.val() == "")
                {
                    default_elo_change.val(32);
                }
                $("#elo_point_distribution").show();
                break;
            case "true_skill":
                $("#rankinglist_initial_value").val(initial_value_trueskill);
                break;
            case "win_loss":
                $("#rankinglist_initial_value").val(initial_value_win_loss);
                break;
            default:
                $("#rankinglist_initial_value").val("0");
                $("#default_point_distribution").show();
                $("#elo_point_distribution").hide();
                break;
        }
    }

    $("#rankinglist_initial_value").on("change", saveInitialValue);
    function saveInitialValue()
    {
        switch($("#rankinglist_game_mode").val()) {
            case "elo":
                initial_value_elo = $("#rankinglist_initial_value").val();
                break;
            case "true_skill":
                initial_value_trueskill = $("#rankinglist_initial_value").val();
                break;
            case "win_loss":
                initial_value_win_loss = $("#rankinglist_initial_value").val();
                break;
            default:
                break;
        }
    }
});

