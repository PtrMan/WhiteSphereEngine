module Client.GuiAbstraction.Color;

/** \brief Color
 *
 */
struct Color
{
   private float R, G, B;

   /** \brief set color as RGB
    *
    * \param R ...
    * \param G ...
    * \param B ...
    */
   final public void setRgb(float R, float G, float B)
   {
      this.R = R;
      this.G = G;
      this.B = B;
   }

   /** \brief return color as RGB
    *
    * \param R ...
    * \param G ...
    * \param B ...
    */
   final public void getRgb(out float R, out float G, out float B)
   {
      R = this.R;
      G = this.G;
      B = this.B;
   }
}
