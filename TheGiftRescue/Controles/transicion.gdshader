shader_type canvas_item;

uniform float progreso : hint_range(0.0, 1.0) = 1.0;
uniform vec2 posicion_santa = vec2(0.5, 0.5);

void fragment() {
    // Ajuste de aspecto para que el círculo no sea un óvalo
    float ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
    vec2 uv = SCREEN_UV;
    
    // Corregimos la distorsión
    uv.x -= 0.5;
    uv.x /= ratio;
    uv.x += 0.5;
    
    vec2 centro = posicion_santa;
    centro.x -= 0.5;
    centro.x /= ratio;
    centro.x += 0.5;
    
    float dist = distance(uv, centro);
    
    // Si la distancia es mayor que el progreso, pintamos negro (alfa 1.0)
    // Usamos 1.5 para asegurar que cubra las esquinas
    float circulo = step(progreso * 1.5, dist);
    
    COLOR = vec4(0.0, 0.0, 0.0, circulo);
}