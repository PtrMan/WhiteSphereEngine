module Client.GuiAbstraction.LoginView;

import Engine.Common.Vector;
import Engine.Common.WideString;
import Engine.Common.Vector;
import Client.GuiAbstraction.Color;
import Client.GuiAbstraction.Button;
import Client.GuiAbstraction.GuiDrawer;
import Client.GuiAbstraction.LoginPresenter;
import Client.GuiAbstraction.EditField;
import Client.GuiAbstraction.Label;

// testing
import Client.GuiAbstraction.MultiTextElement;

// for debugging
import std.stdio;

// TODOCU
// TOUML
class LoginView
{
   this()
   {
      Vector2f SignScale;
      Color CurrentColor;

      this.LoginButton = new Button();
      this.LoginButton.setPosition(new Vector2f(0.4f, 0.8f));
      this.LoginButton.setSize(new Vector2f(0.1f, 0.06f));
      this.LoginButton.setOutlineWidth(0.018f);

      this.LoginButtonText = new WideString();
      this.LoginButtonText.appendDString("Login");

      SignScale = new Vector2f(0.015f, 0.05f);

      this.LoginButton.setText(this.LoginButtonText);
      this.LoginButton.setSignScale(SignScale);

      this.MultiText = new MultiTextElement();

      
      this.MultiText.setPosition(new Vector2f(0.1f, 0.8f));
      
      this.MultiText.Elements ~= new MultiTextElement.Element(MultiTextElement.Element.EnumType.TEXT);
      this.MultiText.Elements[0].Text.appendDString("TEST");
      this.MultiText.Elements[0].SignHeight = 0.08f;
      

      this.MultiText.Elements ~= new MultiTextElement.Element(MultiTextElement.Element.EnumType.NEWLINE);
      this.MultiText.Elements[1].SignHeight = 0.05f;
      
      this.MultiText.Elements ~= new MultiTextElement.Element(MultiTextElement.Element.EnumType.TEXT);
      this.MultiText.Elements[2].Text.appendDString("TEST2");
      this.MultiText.Elements[2].SignHeight = 0.04f;


      this.PasswordField = new EditField();
      this.PasswordField.setPosition(new Vector2f(0.5f-0.35f*0.5f, 0.5f));
      this.PasswordField.setSize(new Vector2f(0.35f, 0.05f));
      this.PasswordField.setSignScale(new Vector2f(0.02f, 0.04f));
      this.PasswordField.setMaxSigns(50); // TODO
      
      CurrentColor.setRgb(1.0f, 0.0f, 0.0f);
      this.PasswordField.setTextColor(CurrentColor);

      CurrentColor.setRgb(0.0f, 0.0f, 1.0f);
      this.PasswordField.setBorderColor(CurrentColor);

      this.PasswordField.setBorderWidth(0.002f);


      this.NameField = new EditField();
      this.NameField.setPosition(new Vector2f(0.5f-0.35f*0.5f, 0.6f));
      this.NameField.setSize(new Vector2f(0.35f, 0.05f));
      this.NameField.setSignScale(new Vector2f(0.02f, 0.04f));
      this.NameField.setMaxSigns(50); // TODO

      CurrentColor.setRgb(1.0f, 0.0f, 0.0f);
      this.NameField.setTextColor(CurrentColor);

      CurrentColor.setRgb(0.0f, 0.0f, 1.0f);
      this.NameField.setBorderColor(CurrentColor);

      this.NameField.setBorderWidth(0.002f);

      WideString StatusLabelString = new WideString();
      StatusLabelString.appendDString("kein status");

      Color StatusLabelColor;
      StatusLabelColor.setRgb(1.0f, 0.0f, 0.0f);

      this.StatusLabel = new Label();
      this.StatusLabel.setPosition(new Vector2f(0.5f-0.3f, 0.8));
      this.StatusLabel.setText(StatusLabelString);
      this.StatusLabel.setColor(StatusLabelColor);
      this.StatusLabel.setSignScale(new Vector2f(0.02f, 0.04f));
   }


   /** \brief renders the stuff
    *
    * \param Drawer the Drawer Object that Draws the stuff
    *
    */
   final public void render(GuiDrawer Drawer)
   {
      WideString Username, Password, Status;

      Username = this.Presenter.getUsername();
      Password = this.Presenter.getPassword();
      Status   = this.Presenter.getStatus();

      this.NameField.setText(Username);
      this.PasswordField.setText(Password);

      this.StatusLabel.setText(Status);

      this.LoginButton.render(Drawer);

      this.MultiText.render(Drawer);

      this.PasswordField.render(Drawer);
      this.NameField.render(Drawer);

      this.StatusLabel.render(Drawer);
   }

   final public void mouseUp(Vector2f Position)
   {
      assert(!(this.Presenter is null), "Presenter was null!");

      // propagate it
      this.LoginButton.mouseUp(Position);

      this.PasswordField.mouseUp(Position);
      this.NameField.mouseUp(Position);

      if( this.LoginButton.WasClicked )
      {
         this.LoginButton.WasClicked = false;

         // send the click event to the presenter
         this.Presenter.fromViewLoginClicked();

         this.Presenter.setFocus(LoginPresenter.EnumFocus.NONE);
      }
      else if( this.PasswordField.WasClicked )
      {
         this.PasswordField.WasClicked = false;

         this.Presenter.setFocus(LoginPresenter.EnumFocus.PASSWORDFIELD);
      }
      else if( this.NameField.WasClicked )
      {
         this.NameField.WasClicked = false;

         this.Presenter.setFocus(LoginPresenter.EnumFocus.NAMEFIELD);
      }
   }

   final public void setPresenter(LoginPresenter Presenter)
   {
      this.Presenter = Presenter;
   }

   private LoginPresenter Presenter;

   private Button LoginButton;
   private WideString LoginButtonText;

   private MultiTextElement MultiText;
   private EditField NameField;
   private EditField PasswordField;
   private Label StatusLabel;
}
