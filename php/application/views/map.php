<? $this->load->view('global/header.php') ?>
<body>
<? $this->load->view('global/user-map-data.php') ?>

<? $this->load->view('global/footer.php') ?>


<script type="text/javascript">
    var isInit=false;
    $( document ).ready( function() {
        var myLatlng = new google.maps.LatLng(42.281 ,-83.738609)
        var mapOptions = {
            zoom: 18,
            center: myLatlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        }
        var map = new google.maps.Map(document.getElementById("map"), mapOptions);

        if(!isInit){
            initialize(map);
        }
        isInit = false;
    });
</script>
</body>
</html>