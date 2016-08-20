module Client.GuiAbstraction.ChatWindowModel;

import Client.GuiAbstraction.IChatWindowModel;
import Client.InputAbstraction;

/** \brief Model of the Chat Window
 *
 * (MVP Pattern)
 */
class ChatWindowModel : IChatWindowModel
{
   private InputAbstraction Input;

   /* \brief ...
    *
    * \return ...
    */
   public uint[] getLastSigns()
   {
      return this.Input.getLastSigns();
   }

   /** \brief set the Input Object from which the data gets transfered
    *
    * \param Input ...
    */
   final public void setInput(InputAbstraction Input)
   {
      this.Input = Input;
   }
}
