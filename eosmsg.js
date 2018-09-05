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

function getCurrentAccount() {
	var tevent = new CustomEvent('getCurrentAccount', {detail: {}});

	window.eosaccountname = "";
	window.parent.dispatchEvent(tevent);

	return window.eosaccountname;
}

function getEOSHttpEndpoint() {
	var tevent = new CustomEvent('getEOSHttpEndpoint', {detail: {}});

	window.eoshttpendpoint = "";
	window.parent.dispatchEvent(tevent);

	return window.eoshttpendpoint;
}

function getEOSChainID() {
	var tevent = new CustomEvent('getEOSChainID', {detail: {}});

	window.eoschainid = "";
	window.parent.dispatchEvent(tevent);

	return window.eoschainid;
}

