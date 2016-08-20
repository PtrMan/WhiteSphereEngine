module guiAbstraction.ChatWindowModel;

import guiAbstraction.IChatWindowModel;
import InputAbstraction;

/** \brief Model of the Chat Window
 *
 * (MVP Pattern)
 */
class ChatWindowModel : IChatWindowModel {
	private InputAbstraction input;

	/* \brief ...
	 *
	 * \return ...
	 */
	uint[] getLastSigns() {
		return input.getLastSigns();
	}

	/** \brief set the Input Object from which the data gets transfered
	 *
	 * \param Input ...
	 */
	final void setInput(InputAbstraction input) {
		this.input = input;
	}
}
