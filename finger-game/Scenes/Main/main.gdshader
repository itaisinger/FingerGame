shader_type canvas_item;

// Reads the screen behind the ColorRect
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Exported variables you can tweak in the Inspector
uniform float pixel_size : hint_range(1.0, 16.0, 1.0) = 4.0;
uniform float color_depth : hint_range(1.0, 32.0, 1.0) = 5.0;
uniform float vignette_intensity : hint_range(0.0, 2.0, 0.1) = 1.0;
uniform float darkening : hint_range(0.0, 1.0, 0.1) = 0.8;

void fragment() {
	// 1. PIXELATION
	// Get the screen resolution and snap the UV coordinates to a grid
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = floor(SCREEN_UV * resolution / pixel_size) * pixel_size / resolution;
	
	// Sample the screen texture using the new chunky UVs
	vec3 color = texture(screen_texture, uv).rgb;
	
	// 2. LESS COLORS (Posterization)
	// Multiplies the color, rounds it off, then divides it back to crush the color palette
	color = floor(color * color_depth) / color_depth;
	
	// 3. DARK & MOODY (Vignette)
	// Calculate distance from the center of the screen
	float dist = distance(SCREEN_UV, vec2(0.5));
	// Create a soft gradient ring
	float vignette = smoothstep(0.8, 0.2, dist * vignette_intensity);
	
	// Apply the vignette and overall darkening
	color = color * vignette * darkening;
	
	COLOR = vec4(color, 1.0);
}