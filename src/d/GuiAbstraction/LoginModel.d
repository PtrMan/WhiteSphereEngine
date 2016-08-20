module Client.GuiAbstraction.LoginModel;

import Client.InputAbstraction;
import Engine.Common.WideString;

import Client.GuiAbstraction.LoginPresenter;

/** \brief Model of the Login Window
 *
 * (MVP Pattern)
 */
class LoginModel
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

   /** \brief called from the core game code to query if the login button was pressed
    *
    * it resets the flag, this means that all successive calls will return false
    *
    * \return ...
    */
   final public bool queryLoginButtonPressed()
   {
      bool Result;

      Result = this.LoginClicked;
      this.LoginClicked = false;

      //return Result;

      // for testing
      return true;
   }

   final public WideString getUsername()
   {
      return this.Presenter.getUsername();
   }

   final public WideString getPassword()
   {
      return this.Presenter.getPassword();
   }

   /** \brief called from the Presenter if the login button was pressed
    *
    */
   final public void fromPresenterLoginClicked()
   {
      this.LoginClicked = true;
   }

   final public void setPresenter(LoginPresenter Presenter)
   {
      this.Presenter = Presenter;
   }

   final public void setStatusMessage(WideString Message)
   {
      this.Presenter.setStatusMessage(Message);
   }

   private bool LoginClicked = false;
   private LoginPresenter Presenter;
}
