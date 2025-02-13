extends Node


func create_white_circle_texture(size: int = 128) -> ImageTexture:
    var image := Image.create(size, size, false, Image.FORMAT_RGBA8)
    image.fill(Color(0, 0, 0, 0))  # Transparent background

    var center := Vector2(size / 2, size / 2)
    var radius := size / 2

    for x in range(size):
        for y in range(size):
            var pos := Vector2(x, y)
            var dist := pos.distance_to(center)
            
            # Calculate the alpha based on the distance to the center of the circle
            var alpha: float = clamp(1.0 - (dist - (radius - 1)) / 2.0, 0.0, 1.0)
            
            if dist <= radius:
                # Interpolate color with the calculated alpha
                var color := Color(1, 1, 1, alpha)
                image.set_pixel(x, y, color)

    var texture := ImageTexture.create_from_image(image)
    return texture
