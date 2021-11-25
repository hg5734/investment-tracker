
const hre = require("hardhat");
const { displayBalance, users } = require('../../utils')
const { expect } = require('chai');
const adapterName = "ConvexProtocolAdapter";

const mim3Crv = "0xFd5AbF66b003881b88567EB9Ed9c651F14Dc4771";
const allUsd3Crv = "0x02E2151D4F351881017ABdF2DD2b51150841d5B3";
const frax3Crv = "0xB900EF131301B307dB5eFcbed9DBb50A3e209B2e";

const cvxrewards = "0xCF50b810E57Ac33B91dCF525C6ddd9881B139332";
let tokens = [mim3Crv, allUsd3Crv, frax3Crv]


// Start test block
describe('Convex-Finance', function () {
    const protocolName = `${web3.eth.abi.encodeParameter('bytes32', web3.utils.toHex('convex-finance'))}`;

    before(async function () {
        const { getNamedAccounts } = hre;
        console.log(await getNamedAccounts())
        this.AdapterRegistry = await ethers.getContractFactory('AdapterRegistry');
        this.adapterRegistry = await this.AdapterRegistry.deploy();
        await this.adapterRegistry.deployed();
        console.log("ADAPTER_REGISTRY", this.adapterRegistry.address);
    });

    before(async function () {
        this.Adapter = await ethers.getContractFactory(adapterName);
        this.adapter = await this.Adapter.deploy();
        await this.adapter.deployed();
        this.protocolAdapterAddress = this.adapter.address;
        console.log("ADAPTER", this.protocolAdapterAddress);
    });

    it('add adapter in registry', async function () {
        await this.adapterRegistry.addProtocolAdapter(protocolName, this.protocolAdapterAddress, tokens);
        const cProtocolName = await this.adapterRegistry._protocolAdapterNames(0);
        console.log(cProtocolName);
        expect(cProtocolName).to.equal(protocolName);
    })

    it('retrieve returns a value previously stored', async function () {
        for (let i = 0; i < users.length; i++) {
            let balances = await this.adapterRegistry.getBalances(users[i]);
            displayBalance(users[i], balances);
        }
    });
});

