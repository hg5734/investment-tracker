
const displayBalance = (user, balances) => {
    let result = {
        user,
    }
    let assets = [];
    let protocol = balances[0];
    let tokens = protocol ? protocol[1] : [];
    for (let j = 0; j < tokens.length; j++) {
        let asset = {
            address: tokens[j][0].toString(),
            balance: tokens[j][1].toString(),
            decimals: tokens[j][2].toString(),
            rewards: [],
        }
        let reward = tokens[j][3];
        for (let k = 0; k < reward.length; k++) {
            asset.rewards.push({
                address: reward[k][0].toString(),
                balance: reward[k][1].toString(),
                decimals: reward[k][2].toString()
            })
        }
        assets.push(asset)
    }
    result.assets = assets;
    console.log(JSON.stringify(result));
}

const users = ["0x7334b486828fcbe6e475ac84fff767bf0f706452", "0xd0b422d70120cc755422bd9b7aecbfa20ad720b8", "0x80b2db70c3fb23e42a52bba84c5064e0175e6167"];

module.exports = {
    displayBalance,
    users
}
