import { APIGatewayEvent } from 'aws-lambda';

type HttpResponse = {
  statusCode: number;
  body?: string;
};

export async function handler(_event: APIGatewayEvent): Promise<HttpResponse> {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'Hello SAM!' }),
  };
}
