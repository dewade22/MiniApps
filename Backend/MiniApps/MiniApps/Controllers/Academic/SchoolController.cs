#nullable disable
using MA.Framework.Application.Controller;
using MA.Framework.Application.Model;
using MA.Framework.Core.Constant;
using MA.Framework.ServiceInterface.Request;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MiniApps.Dto.Academic;
using MiniApps.Model.Request.Academic;
using MiniApps.ServiceInterface.Academic;
using System.ComponentModel.DataAnnotations;
using System.Net;

namespace MiniApps.Controllers.Academic
{
    [ApiController]
    [Route("v/{version:apiversion}/[controller]")]
    [ApiVersion("1.0")]
    public class SchoolController : BaseController
    {
        private readonly ISchoolService _schoolService;

        public SchoolController(ISchoolService schoolService)
        {
            _schoolService = schoolService;
        }

        // ── GET /v1/schools ────────────────────────────────────────────────────
        [HttpGet]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/schools")]
        public async Task<IActionResult> SearchSchools()
        {
            var response = await _schoolService.SearchAsync();
            if (response.IsError())
                return GetApiError(response.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);

            return new OkObjectResult(response.DtoCollection);
        }

        // ── GET /v1/school/{id} ────────────────────────────────────────────────
        [HttpGet]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/school/{id}")]
        public async Task<IActionResult> GetSchool([FromRoute][Required] string id)
        {
            var response = await _schoolService.ReadAsync(new GenericRequest<string> { Data = id });
            if (response.IsError())
                return GetApiError(response.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);

            return new OkObjectResult(response.Data);
        }

        // ── POST /v1/school ────────────────────────────────────────────────────
        [HttpPost]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/school")]
        public async Task<IActionResult> CreateSchool([FromBody] SchoolRequest model)
        {
            var dto = new SchoolDto
            {
                Uuid          = GenerateUuid(UidTableConstant.School),
                Name          = model.Name,
                Code          = model.Code,
                Address       = model.Address,
                City          = model.City,
                Province      = model.Province,
                PostalCode    = model.PostalCode,
                Phone         = model.Phone,
                Email         = model.Email,
                Website       = model.Website,
                PrincipalName = model.PrincipalName,
                Accreditation = model.Accreditation,
                SchoolType    = model.SchoolType,
                EducationLevel = model.EducationLevel,
                IsActive      = model.IsActive,
            };
            PopulateCreatedFields(dto);

            var response = await _schoolService.InsertAsync(new GenericRequest<SchoolDto> { Data = dto });
            if (response.IsError())
                return GetApiError(response.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);

            return Created("", new BasicApiResponse { Uuid = response.Data.Uuid });
        }

        // ── PUT /v1/school/{id} ────────────────────────────────────────────────
        [HttpPut]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/school/{id}")]
        public async Task<IActionResult> UpdateSchool([FromRoute][Required] string id, [FromBody] SchoolRequest model)
        {
            var existing = await _schoolService.ReadAsync(new GenericRequest<string> { Data = id });
            if (existing.IsError())
                return GetApiError(existing.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);

            var dto = existing.Data;
            dto.Name           = model.Name;
            dto.Code           = model.Code;
            dto.Address        = model.Address;
            dto.City           = model.City;
            dto.Province       = model.Province;
            dto.PostalCode     = model.PostalCode;
            dto.Phone          = model.Phone;
            dto.Email          = model.Email;
            dto.Website        = model.Website;
            dto.PrincipalName  = model.PrincipalName;
            dto.Accreditation  = model.Accreditation;
            dto.SchoolType     = model.SchoolType;
            dto.EducationLevel = model.EducationLevel;
            dto.IsActive       = model.IsActive;
            PopulatedUpdatedFields(dto);

            var response = await _schoolService.InsertAsync(new GenericRequest<SchoolDto> { Data = dto });
            if (response.IsError())
                return GetApiError(response.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);

            return Ok();
        }

        // ── DELETE /v1/school/{id} ─────────────────────────────────────────────
        [HttpDelete]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/school/{id}")]
        public async Task<IActionResult> DeleteSchool([FromRoute][Required] string id)
        {
            var existing = await _schoolService.ReadAsync(new GenericRequest<string> { Data = id });
            if (existing.IsError())
                return GetApiError(existing.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);

            var response = await _schoolService.DeleteAsync(new GenericRequest<string> { Data = id });
            if (response.IsError())
                return GetApiError(response.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);

            return Ok();
        }
    }
}
