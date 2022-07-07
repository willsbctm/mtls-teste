using System.Security.Cryptography.X509Certificates;
using Microsoft.AspNetCore.Mvc;

namespace Cliente.Api.Controllers;

[ApiController]
[Route("[controller]")]
public class TesteMtlsController : ControllerBase
{
  private readonly ILogger<TesteMtlsController > logger;

  public TesteMtlsController(ILogger<TesteMtlsController> logger) => this.logger = logger;

  [HttpGet()]
  public async Task<IActionResult> Get()
  {
      logger.LogInformation("Get");

      var certificado = X509Certificate2.CreateFromPemFile("client.crt", "client.key");
      var handler = new HttpClientHandler();
      handler.ClientCertificateOptions = ClientCertificateOption.Manual;
      handler.ClientCertificates.Add(certificado);

      // Certificado auto assinado no servidor por questões de exemplo
      handler.ServerCertificateCustomValidationCallback = HttpClientHandler.DangerousAcceptAnyServerCertificateValidator;

      // Instanciado na mão por questões didáticas
      var client = new HttpClient(handler);
      var resultado = await client.GetAsync("https://test.localdev.me/index.html");
      var conteudo = await resultado.Content.ReadAsStringAsync();

      return Ok(conteudo);
  }
}
