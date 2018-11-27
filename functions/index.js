const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const store = admin.firestore()

exports.createLobby = functions.https.onRequest((req, res) => {

    var arr = [];
    arr.push(req.query.user); 
    console.log(req.query.user);

    return store.collection("euchre").doc(req.query.lobby).set({users: arr})
    .then(success => {
    	res.status(200).send("true");
    }).catch(error => {
    	res.status(500).send("false");
    });

});

exports.getLobbies = functions.https.onRequest((req, res) => {

    return store.collection('euchre').get()
    .then(snap => {
        var data = "";
        snap.forEach(doc => {
            console.log(doc.id, '=>', doc.data());
            data = data + '"' + doc.id + ' ' + doc.data()['users'].length + '/4' + '", '
        });
        if (data == ""){
            res.status(200).send("'[" + '"No lobbies open"' + "]'");
        } else {
            res.status(200).send("'["+data.substring(0,data.length-2)+"]'");
        }
    }).catch(err => {
        res.status(500).send('false');
    });

});

exports.joinLobby = functions.https.onRequest((req, res) => {

    return store.collection("euchre").doc(req.query.lobby).get()
    .then((data) => {

        var usr = data.data()['users']

        if (usr.length <=3){

            usr.push(req.query.user);
            return store.collection("euchre").doc(req.query.lobby).set({users: usr})
            .then((success) => {
                res.status(200).send('true');
            })
            .catch((error) => {
                res.status(500).send('false');
            });

        } else {

            return res.status(200).send('false');

        }

    }).catch((error) => {
        res.status(500).send('false');
    });

});

exports.begin = functions.firestore.document('euchre/{lobby}').onUpdate((change, context) => {

    const newValue = change.after.data();
    const oldValue = change.before.data();

    /*
if (newValue['hands'] && newValue[req.query.id]) {
        return store.collection("euchre").doc(req.query.lobby).get()
        .then(data => {

            var hands = data.data()[req.query.id];
            var users = data.data()["users"];

            //update scores

            var trump = req.query.trump;
            var dealer = req.query.dealer;

            var H = ["DJ","HJ","DA","DK","DQ","D1","D9"].reverse();
            var D = ["HJ","DJ","HA","HK","HQ","H1","H9"].reverse();
            var S = ["SJ","CJ","SA","SK","SQ","S1","S9"].reverse();
            var C = ["CJ","SJ","CA","CK","CQ","C1","C9"].reverse();

            var trump;

            var firstPlay = hands[users(1)];

            if (trump=="C") {
                trump = C;
            } else if (trump=="H") {
                trump = H;
            } else if (trump=="D") {
                trump = D;
            } else {
                trump = S;
            }

            var usr1 = trump.indexOf(hands[users(0)]);
            var usr2 = trump.indexOf(hands[users(1)]);
            var usr3 = trump.indexOf(hands[users(2)]);
            var usr4 = trump.indexOf(hands[users(3)]);

            var obj = {};

            if (usr1+usr2+usr3+usr4>-4) {
                switch(Math.max(usr1,usr2,usr3,usr4)){
                    case usr1:
                    var obj = {};
                    obj[req.query.id] = users(0);
                    break;
                    case usr2:
                    var obj = {};
                    obj[req.query.id] = users(1);
                    break;
                    case usr3:
                    var obj = {};
                    obj[req.query.id] = users(2);
                    break;
                    case usr4:
                    var obj = {};
                    obj[req.query.id] = users(3);
                    break;
                }
            }

            return store.collection("euchre").doc(req.query.lobby).set(obj,{merge:true})
            .then(success => {
                res.status(200).send("true");
            }).catch(error => {
                res.status(500).send("false");
            });

            firstPlay = firstPlay.substring(0,1);

            var fp;

            var H = ["HA","HK","HQ","HJ","H1","H9"].reverse();
            var D = ["DA","DK","DQ","DJ","D1","D9"].reverse();
            var S = ["SA","SK","SQ","SJ","S1","S9"].reverse();
            var C = ["CA","CK","CQ","CJ","C1","C9"].reverse();

            if (firstPlay=="C") {
                fp = C;
            } else if (trump=="H") {
                fp = H;
            } else if (trump=="D") {
                fp = D;
            } else {
                fp = S;
            }

            var usr1 = fp.indexOf(hands[users(0)]);
            var usr2 = fp.indexOf(hands[users(1)]);
            var usr3 = fp.indexOf(hands[users(2)]);
            var usr4 = fp.indexOf(hands[users(3)]);

            delete obj;
            var obj = {};

            switch(Math.max(usr1,usr2,usr3,usr4)){
                case usr1:
                obj[req.query.id] = users(0);
                break;
                case usr2:
                obj[req.query.id] = users(1);
                break;
                case usr3:
                obj[req.query.id] = users(2);
                break;
                case usr4:
                obj[req.query.id] = users(3);
                break;
            }
            return store.collection("euchre").doc(req.query.lobby).set(obj,{merge:true})
            .then(success => {
                res.status(200).send("true");
            }).catch(error => {
                res.status(500).send("false");
            });

        }).catch(error => {
            res.status(500).send("false");
        });
    }
    */

    if (newValue['users'].length==oldValue['users'].length) {
        return null;
    } else if (newValue['users'].length == 4) {

        var users = newValue['users'];
        var data = {};
        var i,j;

        for (j = 1; j<=19; j++) {

            var arr = [ "C9","C1","CJ","CQ","CK","CA","S9","S1","SJ","SQ","SK","SA","H9","H1","HJ","HQ","HK","HA","D9","D1","DJ","DQ","DK","DA"];

            for (i = 23; i>=0; i--) {
                
                var rand = Math.floor(Math.random()*24);
                t = arr[rand];
                arr[rand] = arr[i];
                arr[i] = t;

            }
            data[""+j] = arr;

            delete arr;

        }

        var hands = {};

        Object.keys(data).forEach(key => {
            var val = data[key];
            var k;
            var obj = {}

            for (k = 1; k<=5; k++) {
                if (k<=4){
                    obj[users[k-1]] = val.slice((k-1)*5,(k-1)*5+5);
                } else {
                    obj['kitty'] = val.slice((k-1)*5,(k-1)*5+4);
                }
            }
            hands[key] = obj;
            delete obj;
        });

        return store.doc('euchre/'+context.params.lobby).set({
            hands,
            team1: 0,
            team2: 0
        },{merge: true})
            .then((success) => {
                console.log('Began game at ' + context.params.lobby);
                return;
            })
            .catch((error) => {
                console.log('Tried to begin game at ' + context.params.lobby + 'but something went wrong');
                return;
            });

    } else {return null;}
      
});

exports.lobbyReady = functions.https.onRequest((req, res) => {

    return store.collection("euchre").doc(req.query.lobby).get()
    .then(data => {
        if (data.data()['hands']){
            res.status(200).send("true");
        } else {
            res.status(200).send("false");
        }
    }).catch(error => {
        res.status(500).send("false");
    });

});

exports.hand = functions.https.onRequest((req, res) => {

    return store.collection("euchre").doc(req.query.lobby).get()
    .then(data => {
        res.status(200).send(JSON.stringify(data.data()));
    }).catch(error => {
        res.status(500).send("false");
    });

});

exports.write = functions.https.onRequest((req, res) => {

    var obj = {};

    obj[req.query.user] = req.query.data;
    objj = {};
    objj[req.query.id] = obj;

    console.log(JSON.stringify(objj));
    

    return store.collection("euchre").doc(req.query.lobby).set(objj,{merge: true})
    .then(data => {
        res.status(200).send('true');
    })
    .catch(error => {
        res.status(500).send('false');
    });

});

exports.read = functions.https.onRequest((req, res) => {

    return store.collection("euchre").doc(req.query.lobby).get()
    .then(data => {
        var k = {};
        if (data.data()[req.query.id]) {
            k = data.data()[req.query.id];
        }
        res.status(200).send(JSON.stringify(k));
    }).catch(error => {
        res.status(500).send("false");
    });

});