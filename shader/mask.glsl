// GLSL shader code for applying a mask with dynamic alpha
extern Image mask; // The mask image
extern vec2 mask_position; // The mask's position
extern float mask_alpha; // Alpha value for the mask

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    // Calculate mask coordinates relative to the screen coordinates
    vec2 mask_coords = screen_coords - mask_position;

    // Get the mask color (using mask_coords in the mask image space)
    vec4 maskColor = Texel(mask, mask_coords);

    // Apply alpha to the mask color
    maskColor.a *= mask_alpha;

    // Return the mask color applied to the texture
    return vec4(color.rgb, color.a * maskColor.a);
}
