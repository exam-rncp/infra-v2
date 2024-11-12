module "acm" {
  source      = "terraform-aws-modules/acm/aws"
  version     = "~> 4.0"
  domain_name = local.domain_name
  zone_id     = data.cloudflare_zone.this.id
  subject_alternative_names = [
    "*.app.${local.domain_name}",
    "*.exam.${local.domain_name}"
  ]
  create_route53_records  = false
  validation_method       = "DNS"
  wait_for_validation     = true
  validation_record_fqdns = cloudflare_record.validation[*].hostname
  tags = {
    Cluster     = local.cluster_name
    Provider    = "cloudflare"
    Environment = "staging"
  }

  depends_on = [module.vpc, module.eks]
}

resource "cloudflare_record" "validation" {
  count           = length(module.acm.distinct_domain_names)
  zone_id         = data.cloudflare_zone.this.id
  name            = element(module.acm.validation_domains, count.index)["resource_record_name"]
  type            = element(module.acm.validation_domains, count.index)["resource_record_type"]
  value           = trimsuffix(element(module.acm.validation_domains, count.index)["resource_record_value"], ".")
  ttl             = 60
  proxied         = false
  allow_overwrite = true
}

data "cloudflare_zone" "this" {
  name = local.domain_name
}