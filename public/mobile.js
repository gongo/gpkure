$(document).ready(function(){
    var GpkureNotification = {
        success: function() {
            noty({
                text: 'thanks!',
                type: 'success',
                layout: 'bottom',
                timeout: 5000
            });
        },

        failure: function() {
            noty({
                text: 'invalid...',
                type: 'warning',
                layout: 'bottom',
                timeout: 5000
            });
        }
    };

    $('#gift').click(function() {
        $.post(
            '/',
            { serial: $('#serial').val() },
            function(data) {
                if (data === 'ok') {
                    GpkureNotification.success();
                } else {
                    GpkureNotification.failure();
                }
            }
        );
    });
});
