$( document ).on('turbolinks:load', function() {
    $('#exampleModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget) // Button that triggered the modal
        var chosenEvent = button.data('whatever') // Extract info from data-* attributes
        // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
        // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
        var modal = $(this)
        modal.ajax({
            url: "/teams/search",
            type: "POST",
            dataType: 'json',
            data: chosenEvent,
            processResults: function (data) {
                console.log(data)
                }
            })
        modal.find('.modal-title').text('New message to ' + chosenEvent)
        modal.find('.modal-body input').val(chosenEvent.teams)
    })
});