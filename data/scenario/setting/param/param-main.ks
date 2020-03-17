[iscript]

sf.game = {
  map_size: 400,
};

sf.camera_size = 50;
sf.camera_button = [];
for (i=0; i<=18; i++) {
  if (i<9) {
    sf.camera_button[i] = [];
    sf.camera_button[i][0] = 1280 - sf.camera_size - 25;
    sf.camera_button[i][1] = 25 + (sf.camera_size*i);
  } else if (i>=9) {
    sf.camera_button[i] = [];
    sf.camera_button[i][0] = 1280 - sf.camera_size - 100;
    sf.camera_button[i][1] = 50 + (sf.camera_size*(i-9));
  }
}

[endscript]
[return]
