function signAndPush(contract, action) {
	alert("action " + contract + " - " +action);
}

function adjustIFrameHeigth(heigth) {
	alert("adjust " + heigth);
}

function transfer(pto, pamount, pmemo) {
	var tevent = new CustomEvent('transfer', {detail: {to: pto, amount: pamount, memo: pmemo}});

	window.parent.dispatchEvent(tevent);
}

