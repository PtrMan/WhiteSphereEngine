module Client.GuiAbstraction.IChatWindowModel;

/** \brief Interface for the Model of the Chat window
 */
interface IChatWindowModel
{
   /** \brief returns the last pressed signs
    *
    * \return ...
    */
   public uint[] getLastSigns();
}
