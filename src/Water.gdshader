shader_type canvas_item;

uniform sampler2D refraction_map;

uniform vec2 refraction_stretch = vec2(1.0, 1.0);
uniform float refraction_strength = 0.02; // Replace hint_range with a comment about the range (0.0 to 0.1)

uniform vec4 water_tint = vec4(0.2, 0.6, 1.0, 0.1); // Remove source_color
uniform float speed = 0.5; // Replace hint_range with a comment about the range (0.0 to 1.0)

void fragment() {
    // Use global UV coordinates
    vec2 uv = SCREEN_UV;

    // Calculate animated texture coordinates for refraction
    vec2 refraction_uv = vec2(
        mod(uv.x * refraction_stretch.x + TIME * speed, 1.0),
        mod(uv.y * refraction_stretch.y + TIME * speed, 1.0)
    );

    // Get the refraction offset
    vec2 refraction_offset = texture(refraction_map, refraction_uv).xy - 0.5;

    // Apply refraction offset to the screen texture
    vec4 refraction = texture(SCREEN_TEXTURE, uv - refraction_offset * refraction_strength);

    // Blend with the water tint
    vec4 color = vec4(1.0);
    color.rgb = mix(refraction.rgb, water_tint.rgb, water_tint.a);
    COLOR = color;
}
