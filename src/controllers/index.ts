import * as express from 'express';
import {DeployService} from '../services/deploy.service';

export default function entryPoint(app : express.Application) {

    app.get('/', async function (req: express.Request, res: express.Response) {
        let response: any = { status: 200, message: 'Welcome to Partner Hub API', body: { version: '2.2.0', vendor: { name: 'Loyyal Holdings' } } };
        return res.status(200).send(response);
    });

    /**Deploy a contract */
    app.post('/v1/contract/deploy', async function (req: express.Request, res: express.Response) {
        const response: any = await new DeployService().contractDeployment(req);
        return res.status(response.status).send(response);
    });

    /**interface format */
    app.post('/v1/contract/interfaces/generate', async function (req: express.Request, res: express.Response) {
        const response: any = await new DeployService().generateInterface(req);
        return res.status(response.status).send(response);
    });

    /**save the contract interface */
    app.post('/v1/contract/interfaces', async function (req: express.Request, res: express.Response) {
        const response: any = await new DeployService().broadcastInterface(req);
        return res.status(response.status).send(response);
    });

    /**Create an HTTP API for the contract */
    app.post('/v1/contract/apis', async function (req: express.Request, res: express.Response) {
        const response: any = await new DeployService().createContractApis(req);
        return res.status(response.status).send(response);
    });

    /**Invoke contract */
    app.post('/v1/contract/apis/invoke', async function (req: express.Request, res: express.Response) {
        const response: any = await new DeployService().invokeContract(req);
        return res.status(response.status).send(response);
    });
}
