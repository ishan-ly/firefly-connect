import * as express from 'express';
import TokensService from '../services/tokens.service';


export default function TokenController(app : express.Application) {

    /**Create a pool using default token factory */
    app.post('/v1/tokens/pools', async function (req: express.Request, res: express.Response) {
        const response: any = await new TokensService().createPool(req);
        return res.status(response.status).send(response);
    });

    /**Mint Tokens */
    app.post('/v1/tokens/mint', async function (req: express.Request, res: express.Response) {
        const response: any = await new TokensService().mintTokens(req);
        return res.status(response.status).send(response);
    });

    /**Transfer tokens */
    app.post('/v1/tokens/transfers', async function (req: express.Request, res: express.Response) {
        const response: any = await new TokensService().transferTokens(req);
        return res.status(response.status).send(response);
    });

    /**Burn tokens */
    app.post('/v1/tokens/burn', async function (req: express.Request, res: express.Response) {
        const response: any = await new TokensService().burnTokens(req);
        return res.status(response.status).send(response);
    });

    /**Token approvals */
    app.post('/v1/tokens/approvals', async function (req: express.Request, res: express.Response) {
        const response: any = await new TokensService().approveTokens(req);
        return res.status(response.status).send(response);
    });


}


