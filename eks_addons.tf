# ################################################################################
# # EKS Blueprints Addons
# ################################################################################

module "ebs_csi_driver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.20"

  role_name_prefix = "${local.cluster_name}-ebs-csi-driver-"

  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = {
    Driver = "true"
  }

  depends_on = [module.eks]
}


module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.18"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  eks_addons = {

    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
    }

    coredns = {
      most_recent = true

      timeouts = {
        create = "25m"
        delete = "10m"
      }
    }

    vpc-cni = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }
  }

  enable_cluster_autoscaler = true
  enable_ingress_nginx      = true
  ingress_nginx = {
    name          = "external"
    chart_version = "4.11.3"
    repository    = "https://kubernetes.github.io/ingress-nginx"    
    chart            = "ingress-nginx"
    namespace        = "ingress-nginx"
    values        = [file("./ingress_controller.yaml")]

    set = [{
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
      value = module.acm.acm_certificate_arn
      type  = "string"
    }]
  }

  enable_metrics_server = true
  metrics_server = {
    name          = "metrics-server"
    chart_version = "3.12.0"
    repository    = "https://kubernetes-sigs.github.io/metrics-server/"
    namespace     = "kube-system"
    values        = [file("./metrics_server.yaml")]
  }

  enable_argocd = true
  argocd = {
    name       = "argocd"
    version    = "7.6.12"
    repository = "https://argoproj.github.io/argo-helm"
    namespace  = "argocd"
    values     = [file("./argocd.yaml")]

    set = [{
      name  = "server.ingress.annotations.nlb\\.ingress\\.kubernetes\\.io/certificate-arn"
      value = module.acm.acm_certificate_arn
      type  = "string"
    }]
  }

  depends_on = [module.eks]
}