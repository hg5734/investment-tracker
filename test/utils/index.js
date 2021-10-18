
export const displayBalance = (balances) =>{
    let protocol = balances[i];
    let tokens = protocol[1];
    for (let j = 0; j < tokens.length; j++) {
        console.log({
            [tokens[j][0]] : tokens[j][1].toString()
        });
    }
}
