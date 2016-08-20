module Client.GuiAbstraction.LoginPresenter;

import Client.GuiAbstraction.LoginModel;
import Client.GuiAbstraction.LoginView;
import Engine.Common.WideString;

/** \brief Presneter for the Login
 *
 * Is after the MVP pattern
 */
// TOUML
// TODOCU
class LoginPresenter
{
   public enum EnumFocus
   {
      NONE,
      NAMEFIELD,
      PASSWORDFIELD
   }

   this()
   {
      this.Username = new WideString();
      this.Password = new WideString();

      // just for testing
      this.Username.appendDString("tester0");
      this.Password.appendDString("tester0");

      this.Status   = new WideString();
   }

   final public void fromViewLoginClicked()
   {
      this.Model.fromPresenterLoginClicked();
   }

   /** \brief Manages all stuff of the Presenter
    *
    */
   final public void doIt()
   {
      uint []LastSigns;
      WideString InputString;

      // get new Signs from the Model and append it to the text in the EditField
      LastSigns = this.Model.getLastSigns();

      foreach(Sign; LastSigns)
      {
         if( this.Focus == EnumFocus.PASSWORDFIELD )
         {
            this.Password.appendChar(cast(char)Sign);
         }
         else if( this.Focus == EnumFocus.NAMEFIELD )
         {
            this.Username.appendChar(cast(char)Sign);
         }
      }
   }

   final public void setFocus(EnumFocus Focus)
   {
      this.Focus = Focus;
   }

   final public WideString getUsername()
   {
      return this.Username;
   }

   final public WideString getPassword()
   {
      return this.Password;
   }

   final public WideString getStatus()
   {
      return this.Status;
   }

   final public void setStatusMessage(WideString Message)
   {
      this.Status = Message;
   }

   final public void setModel(LoginModel Model)
   {
      this.Model = Model;
   }

   final public void setView(LoginView View)
   {
      this.View = View;
   }

   private LoginModel Model;
   private LoginView View;

   private WideString Username;
   private WideString Password;
   private WideString Status;

   private EnumFocus Focus = EnumFocus.NONE; /**< which input thing does have the focus? */
}
