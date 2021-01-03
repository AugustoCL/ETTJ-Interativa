### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 87fefce0-02c5-11eb-3bc6-ad05fe23cf93
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add("Plots")
	Pkg.add("PlutoUI")
	using Plots
	using PlutoUI
end

# ╔═╡ 3a7f37b0-02c9-11eb-28d5-1d8d43c6f44a
md"### Curva de Juros Interativa (Nelson-Siegel-Svensson)"

# ╔═╡ 5e857a22-02c9-11eb-2c2b-97f06fbcf1a8
md"Este pluto notebook permite interagir com os 6 parâmetros **β₀, β₁, β₂, β₃, λ₁, λ₂** do modelo de curva de juros de Nelson-Siegel-Svensson, gerando a visualização interativa da curva de juros. 

Deste modo, é possível observar o impacto que cada parâmetro tem sobre o comportamento da curva de juros."

# ╔═╡ abc28efe-02db-11eb-12a1-e3aa3ea94d5f
md"O modelo segue a seguinte formulação:

$y_{t}(\tau)=\beta_{0, t}+\beta_{1, t} \left(\frac{1-e^{-\lambda_{1, x} \tau}}{\lambda_{1, t} \cdot \tau}\right)+\beta_{2, t} \left(\frac{1-e^{-\lambda_{1, x} \tau}}{\lambda_{1, t} \cdot \tau}-e^{-\lambda_{1, x} \cdot \tau}\right)+\beta_{3, t} \left(\frac{1-e^{-\lambda_{2, x} \cdot \tau}}{\lambda_{2, t} \cdot \tau}-e^{-\lambda_{2, x} \cdot \tau}\right)$"

# ╔═╡ c633a440-02c8-11eb-185a-8b3e594df121
begin
	n = @bind n Slider(5:100, default=25, show_value=true)
	β₀ = @bind β₀ Slider(0.01:0.001:1.0, default=0.05, show_value=true)
	β₁ = @bind β₁ Slider(-1:0.01:1.0, default=-0.05, show_value=true)
	β₂ = @bind β₂ Slider(-1:0.01:1.0, default=-0.1, show_value=true)
	β₃ = @bind β₃ Slider(-1:0.01:1.0, default=-0.05, show_value=true)
	λ₁ = @bind λ₁ Slider(0.01:0.01:2.0, default=0.1, show_value=true)
	λ₂ = @bind λ₂ Slider(0.01:0.01:1.0, default=0.08, show_value=true)
	
	md"""**Parâmetros da Curva de Juros**
	
	**N°**: $(n) 	Número de Obs. (21 du)
	
	**β₀**: $(β₀)	Fator de Nível (Longo Prazo)  
	
	**β₁**: $(β₁)	Fator de Inclinação (Curto Prazo)
	
	**β₂**: $(β₂)	Fator de Curvatura (Médio Prazo)
	
	**β₃**: $(β₃)	Fator de Curvatura (Médio Prazo)

	**λ₁**: $(λ₁)   Velocidade de Decaimento (Médio Prazo)
	
	**λ₂**: $(λ₂)	Velocidade de Decaimento (Médio Prazo)"""
end

# ╔═╡ bdab38e0-02c5-11eb-09cf-43a08fb6bf8b
begin 
	x = collect(21:21:(n*21))
	x[1] = 21
	@show x
end

# ╔═╡ b74b0b10-02ca-11eb-17cb-f5c8fdc4ee50
begin
	nss(β₀, β₁, β₂, β₃, λ₁, λ₂, t) =   β₀ +
									β₁*((1-exp(-λ₁*t))/(λ₁*t)) +
									β₂*((1-exp(-λ₁*t))/(λ₁*t) - exp(-λ₁*t)) +
									β₃*((1-exp(-λ₂*t))/(λ₂*t) - exp(-λ₂*t))
	y = [nss(β₀, β₁, β₂, β₃, λ₁, λ₂, i)*100 for i in x]
end

# ╔═╡ 3a9d9420-02d4-11eb-2df5-a12b2a9eecb8
begin
	gr()
	plot(x, y, 
		leg=false,
		title="Curva de Juros (NSS)",
		xlabel="Vencimento em dias úteis", ylabel="% a.a",
		ylim=(-3,10),
		c=:blue, lw=3, 
		shape=:hexagon, 
		msize=4, # msize equivale a markersize 
		markercolor=:white, 
		markeralpha=1)
	plot!([-1, n*21], [0,0], c=:black, lab="", l=:dash)
end

# ╔═╡ Cell order:
# ╟─3a7f37b0-02c9-11eb-28d5-1d8d43c6f44a
# ╟─5e857a22-02c9-11eb-2c2b-97f06fbcf1a8
# ╟─abc28efe-02db-11eb-12a1-e3aa3ea94d5f
# ╠═87fefce0-02c5-11eb-3bc6-ad05fe23cf93
# ╟─c633a440-02c8-11eb-185a-8b3e594df121
# ╟─3a9d9420-02d4-11eb-2df5-a12b2a9eecb8
# ╟─bdab38e0-02c5-11eb-09cf-43a08fb6bf8b
# ╟─b74b0b10-02ca-11eb-17cb-f5c8fdc4ee50
