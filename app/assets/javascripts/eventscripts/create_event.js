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
        console.log("durationChange");
        console.log($("#event_enddate").val());

        if(start != "" && gameday_dur != "" && system != "" && gameday_dur != undefined && system != undefined)
        {
            rounds = calcRounds(system,participants);
            var number_of_days = rounds * parseInt(gameday_dur);
            $("#event_enddate").val(addDays(start,number_of_days));

        }
        console.log($("#event_enddate").val());
        changeDur();
    }
    function adaptDuration() {


        var start = $("#event_startdate").val();
        var end = $("#event_enddate").val();
        var system = $("#league_game_mode").val();
        var gameday_dur =$("#league_gameday_duration").val();
        var participants = $("#league_max_teams").val();
        console.log("gamedayCHange");
        console.log(end);
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
      var start = new Date(startdatestr);
      var end = new Date(enddatestr);

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
    }

    //rankinglist_game_mode -> rankinglist_initial_value
    showInitialValue();
    var initial_value_elo = "1000";
    var initial_value_trueskill = "25";
    var initial_value_win_loss = "0";
    $("#rankinglist_game_mode").on("change", showInitialValue);
    function showInitialValue()
    {
        console.log(initial_value_win_loss + initial_value_trueskill + initial_value_elo);
        switch($("#rankinglist_game_mode").val())
        {
            case "elo":
                $("#rankinglist_initial_value").val(initial_value_elo);
                break;
            case "true_skill":
                $("#rankinglist_initial_value").val(initial_value_trueskill);
                break;
            case "win_loss":
                $("#rankinglist_initial_value").val(initial_value_win_loss);
                break;
            default:
                $("#rankinglist_initial_value").val("0");
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

