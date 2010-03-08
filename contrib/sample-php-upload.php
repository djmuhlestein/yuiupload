<?php
// customize the storage location, error messages, etc
// to suit your specific site.
header("content-type: text/html"); // the return type must be text/html
//if file has been sent successfully:
if (isset($_FILES['image']['tmp_name'])) {
 // open the file
 $img = $_FILES['image']['tmp_name'];
 $himage = fopen ( $img, "r"); // read the temporary file into a buffer
 $image = fread ( $himage, filesize($img) );
 fclose($himage);
 //if image can't be opened, either its not a valid format or even an image:
 if ($image === FALSE) {
  echo "{status:'Error Reading Uploaded File.'}";
  return;
 }
 // create a new random numeric name to avoid rewriting other images already on the server...
 $ran = rand ();
 $ran2 = $ran.".";
 // define the uploading dir
 $path = "editor_images/";
 // join path and name
 $path = $path . $ran2.'jpg';
 // copy the image to the server, alert on fail
 $hout=fopen($path,"w");
 fwrite($hout,$image);
 fclose($hout);
 //you'll need to modify the path here to reflect your own server.
 $path = "/wp-content/uploads/2007/12/" . $path;
 echo "{status:'UPLOADED', image_url:'$path'}";
} else {
 echo "{status:'No file was submitted'}";
}
?>

