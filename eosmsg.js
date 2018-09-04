function signAndPush(contract, action) {
	alert("action " + contract + " - " +action);
}

function adjustIFrameHeigth(h) {
	var tevent = new CustomEvent('adjustIFrameHeight', {detail: {height: h}});

	window.parent.dispatchEvent(tevent);
}

function transfer(pto, pamount, pmemo) {
	var tevent = new CustomEvent('transfer', {detail: {to: pto, amount: pamount, memo: pmemo}});

	window.parent.dispatchEvent(tevent);
}

