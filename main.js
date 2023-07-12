const core = require("@actions/core");
const compose = require("docker-compose");
const utils = require("./utils");
const web3 = require('web3');

try {

  // Create a wallet to use
  const wallet = web3.eth.accounts.create(web3.utils.randomHex(32));
  console.log("wallet created:", wallet.address);
      
  const composeFiles = utils.parseComposeFiles(
    core.getMultilineInput("compose-file")
  );
  if (!composeFiles.length) {
    return;
  }

  const services = core.getMultilineInput("services", { required: false });

  const options = {
    config: composeFiles,
    log: true,
    composeOptions: utils.parseFlags(core.getInput("compose-flags")),
    commandOptions: utils.parseFlags(core.getInput("up-flags")),
  };

  const promise =
    services.length > 0
      ? compose.upMany(services, options)
      : compose.upAll(options);

  promise
    .then(() => {
      console.log("compose started");
      return compose.exec('lotus', `lotus send ${wallet.address} 888`)
    })
    .then(() => {
      console.log("wallet funded:", wallet.address);
      core.setOutput("wallet", wallet.address);
      core.setOutput("privateKey", wallet.privateKey);
    })
    .catch((err) => {
      core.setFailed(`compose up failed ${JSON.stringify(err)}`);
    });

} catch (error) {
  core.setFailed(error.message);
}
